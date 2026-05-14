import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/services/app_action_service.dart';
import 'package:rbc_flutter_professional/core/services/rbc_notification_service.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/festival/festival_api.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/section_header.dart';
import 'package:timezone/timezone.dart' as tz;

class EventHubScreen extends StatefulWidget {
  const EventHubScreen({super.key});

  @override
  State<EventHubScreen> createState() => _EventHubScreenState();
}

class _EventHubScreenState extends State<EventHubScreen> {
  final DeviceCalendarPlugin calendarPlugin = DeviceCalendarPlugin();

  late Future<List<_CalendarEventItem>> eventsFuture;

  final titleController = TextEditingController();
  final noteController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<_CalendarEventItem> localAddedEvents = [];

  @override
  void initState() {
    super.initState();
    eventsFuture = _loadEvents();
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  DateTime get todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _onlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _dateWithTime(DateTime date, TimeOfDay? time) {
    final t = time ?? const TimeOfDay(hour: 9, minute: 0);

    return DateTime(
      date.year,
      date.month,
      date.day,
      t.hour,
      t.minute,
    );
  }

  Future<List<_CalendarEventItem>> _loadEvents() async {
    // 1. Load Backend Events
    final backendRaw = await FestivalApi(ApiClient.instance).events();
    final backendEvents = backendRaw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .map((item) {
          final rawDate = '${item['date'] ?? item['startDate'] ?? ''}';
          final date = DateTime.tryParse(rawDate);

          if (date == null) return null;

          return _CalendarEventItem(
            title: '${item['title'] ?? item['title'] ?? 'RBC ইভেন্ট'}',
            description: '${item['subtitle'] ?? item['subtitle'] ?? ''}',
            date: date,
            source: 'RBC',
            addedToCalendar: false,
          );
        })
        .whereType<_CalendarEventItem>()
        .where((event) => !_onlyDate(event.date).isBefore(todayStart))
        .toList();


    // 2. Load Native Device Calendar Events (Read Operation Fix)
    final deviceEvents = await _loadDeviceCalendarEvents();

    // 3. Combine All
    final localUpcoming = localAddedEvents
        .where((event) => !_onlyDate(event.date).isBefore(todayStart))
        .toList();

    final allEvents = [
      ...localUpcoming,
      ...backendEvents,
      ...deviceEvents,
    ];

    // Remove duplicates based on title and date to prevent clutter
    final uniqueEvents = <String, _CalendarEventItem>{};
    for (var event in allEvents) {
      final key = '${event.title}_${_onlyDate(event.date).toIso8601String()}';
      if (!uniqueEvents.containsKey(key) || event.addedToCalendar) {
        uniqueEvents[key] = event; // Prefer items marked as added to calendar
      }
    }

    final finalList = uniqueEvents.values.toList();
    finalList.sort((a, b) => a.date.compareTo(b.date));

    return finalList;
  }

  // Actual READ operation from the user's native calendar
  Future<List<_CalendarEventItem>> _loadDeviceCalendarEvents() async {
    try {
      final hasPermission = await _ensureCalendarPermission();
      if (!hasPermission) return [];

      final result = await calendarPlugin.retrieveCalendars();
      if (result.isSuccess == false || result.data == null) return [];

      final writableCalendars = result.data!.where((c) => c.isReadOnly != true);
      List<_CalendarEventItem> fetchedEvents = [];

      final startDate = tz.TZDateTime.now(tz.local);
      final endDate = tz.TZDateTime.now(tz.local).add(const Duration(days: 365));

      for (final calendar in writableCalendars) {
        if (calendar.id == null) continue;

        final eventsResult = await calendarPlugin.retrieveEvents(
          calendar.id!,
          RetrieveEventsParams(startDate: startDate, endDate: endDate),
        );

        if (eventsResult.isSuccess == true && eventsResult.data != null) {
          for (final e in eventsResult.data!) {
            if (e.start != null) {
              fetchedEvents.add(_CalendarEventItem(
                title: e.title ?? 'Unknown Event',
                description: e.description ?? '',
                date: e.start!.toLocal(), // Convert TZDateTime back to normal DateTime
                source: 'Device Calendar',
                addedToCalendar: true,
              ));
            }
          }
        }
      }
      return fetchedEvents;
    } catch (e) {
      debugPrint('Read Calendar Error: $e');
      return [];
    }
  }

  Future<void> _refresh() async {
    setState(() {
      eventsFuture = _loadEvents();
    });
    await eventsFuture;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: todayStart,
      lastDate: DateTime(now.year + 10, 12, 31),
      helpText: 'ইভেন্টের তারিখ নির্বাচন করুন',
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: 'ইভেন্টের সময় নির্বাচন করুন',
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Future<bool> _ensureCalendarPermission() async {
    var permissionsGranted = await calendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && permissionsGranted.data!) {
      return true;
    }
    permissionsGranted = await calendarPlugin.requestPermissions();
    return permissionsGranted.isSuccess && permissionsGranted.data == true;
  }

  Future<String?> _writableCalendarId() async {
    final allowed = await _ensureCalendarPermission();
    if (!allowed) {
      _message('Calendar permission allow করুন');
      return null;
    }

    final result = await calendarPlugin.retrieveCalendars();
    
    if (result.isSuccess == false) {
      _message('Calendar fetch error: ${result.errors.first.errorMessage}');
      return null;
    }

    final calendars = result.data ?? [];
    
    // First try to find the default calendar
    for (final calendar in calendars) {
      if (calendar.isDefault == true && calendar.isReadOnly != true) {
        return calendar.id;
      }
    }

    // Fallback to any writable calendar
    for (final calendar in calendars) {
      if (calendar.isReadOnly != true && calendar.id != null) {
        return calendar.id;
      }
    }

    return null;
  }

  Future<void> _saveToDeviceCalendar(_CalendarEventItem item) async {
    try {
      final calendarId = await _writableCalendarId();

      if (calendarId == null || calendarId.isEmpty) {
        _message('Writable calendar পাওয়া যায়নি');
        return;
      }

      // Timezone dependency here! Will fail if tz.initializeTimeZones() isn't called in main.dart
      final start = tz.TZDateTime.from(item.date, tz.local);
      final end = tz.TZDateTime.from(
        item.date.add(const Duration(hours: 1)),
        tz.local,
      );

      final event = Event(
        calendarId,
        title: item.title,
        description: item.description.isEmpty
            ? 'রূপসী বাংলা ক্লাব ইভেন্ট'
            : item.description,
        start: start,
        end: end,
        reminders: [
          Reminder(minutes: 24 * 60), // 1 day before
          Reminder(minutes: 60),      // 1 hour before
        ],
      );

      final result = await calendarPlugin.createOrUpdateEvent(event);

      if (result?.isSuccess == true && result?.data != null) {
        await RbcNotificationService.scheduleEventReminder(
          title: item.title,
          eventDate: item.date,
          note: item.description,
        );

        _message('Calendar-এ সফলভাবে যুক্ত হয়েছে!');

        setState(() {
          if (!localAddedEvents.contains(item)) {
            localAddedEvents.add(item.copyWith(addedToCalendar: true));
          }
          eventsFuture = _loadEvents(); // Reload to show updated state
        });
      } else {
        // Expose the EXACT native error message from iOS/Android
        final errors = result?.errors.map((e) => e.errorMessage).join(', ') ?? 'Unknown error';
        _message('Error saving event: $errors');
      }
    } catch (e) {
      // Catch exceptions like uninitialized timezones
      _message('System Error: $e');
      debugPrint('Calendar Write Exception: $e');
    }
  }

  Future<void> _addOwnEvent() async {
    final title = titleController.text.trim();
    final note = noteController.text.trim();

    if (title.isEmpty) {
      _message('ইভেন্টের নাম লিখুন');
      return;
    }

    if (selectedDate == null) {
      _message('ইভেন্টের তারিখ নির্বাচন করুন');
      return;
    }

    final eventDate = _dateWithTime(selectedDate!, selectedTime);

    if (_onlyDate(eventDate).isBefore(todayStart)) {
      _message('পুরাতন তারিখে ইভেন্ট যোগ করা যাবে না');
      return;
    }

    final newItem = _CalendarEventItem(
      title: title,
      description: note,
      date: eventDate,
      source: 'আপনার যোগ করা',
      addedToCalendar: false,
    );

    await _saveToDeviceCalendar(newItem);

    titleController.clear();
    noteController.clear();

    setState(() {
      selectedDate = null;
      selectedTime = null;
    });
  }

  void _openGoogleCalendar() {
    AppActionService.openInsideApp(
      context,
      'Google Calendar',
      'https://calendar.google.com/calendar/u/0/r',
    );
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('আমাদের অনুষ্ঠান'),
      ),
      body: RefreshIndicator(
        color: RbcColors.primary,
        onRefresh: _refresh,
        child: FutureBuilder<List<_CalendarEventItem>>(
          future: eventsFuture,
          builder: (context, snapshot) {
            final loading = snapshot.connectionState == ConnectionState.waiting;

            if (loading) {
              return const LoadingView();
            }

            final items = snapshot.data ?? [];

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                _HeroCard(onOpenCalendar: _openGoogleCalendar),
                const SizedBox(height: 18),
                _AddEventForm(
                  titleController: titleController,
                  noteController: noteController,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  onPickDate: _pickDate,
                  onPickTime: _pickTime,
                  onSubmit: _addOwnEvent,
                ),
                const SizedBox(height: 22),
                const SectionHeader(
                  title: 'আজ ও আসন্ন ইভেন্ট',
                  subtitle: '',
                ),
                const SizedBox(height: 12),
                if (snapshot.hasError)
                  _ErrorEventView(onRetry: _refresh)
                else if (items.isEmpty)
                  const _EmptyEventView()
                else
                  ...items.map(
                    (item) => _EventCard(
                      item: item,
                      onAddToCalendar: () => item.addedToCalendar 
                          ? _message('ইতিমধ্যে Calendar-এ আছে')
                          : _saveToDeviceCalendar(item),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CalendarEventItem {
  const _CalendarEventItem({
    required this.title,
    required this.description,
    required this.date,
    required this.source,
    required this.addedToCalendar,
  });

  final String title;
  final String description;
  final DateTime date;
  final String source;
  final bool addedToCalendar;

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  _CalendarEventItem copyWith({
    bool? addedToCalendar,
  }) {
    return _CalendarEventItem(
      title: title,
      description: description,
      date: date,
      source: source,
      addedToCalendar: addedToCalendar ?? this.addedToCalendar,
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.onOpenCalendar,
  });

  final VoidCallback onOpenCalendar;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      highlight: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'রূপসী বাংলা ক্লাব ইভেন্ট',
            style: TextStyle(
              color: RbcColors.accent,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'আমরা আপনাকে স্মরণ করিয়ে দিব আপনার উৎসব',
            style: TextStyle(
              color: RbcColors.surface.withOpacity(.82),
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddEventForm extends StatelessWidget {
  const _AddEventForm({
    required this.titleController,
    required this.noteController,
    required this.selectedDate,
    required this.selectedTime,
    required this.onPickDate,
    required this.onPickTime,
    required this.onSubmit,
  });

  final TextEditingController titleController;
  final TextEditingController noteController;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate == null
        ? 'তারিখ নির্বাচন করুন'
        : DateFormat('dd MMMM yyyy').format(selectedDate!);

    final timeText = selectedTime == null
        ? 'সময় নির্বাচন করুন'
        : selectedTime!.format(context);

    return ProCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'নিজের ইভেন্ট Calendar-এ যুক্ত করুন',
            style: TextStyle(
              color: RbcColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'ইভেন্টের নাম',
              hintText: 'যেমন: পূজা প্রস্তুতি সভা',
              prefixIcon: Icon(Icons.event_note_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: noteController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'বিস্তারিত / নোট',
              hintText: 'সময়, স্থান বা প্রয়োজনীয় তথ্য লিখুন',
              prefixIcon: Icon(Icons.notes_rounded),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onPickDate,
            icon: const Icon(Icons.calendar_today_rounded),
            label: Text(dateText),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onPickTime,
            icon: const Icon(Icons.access_time_rounded),
            label: Text(timeText),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: RbcColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: onSubmit,
              icon: const Icon(Icons.event_available_rounded),
              label: const Text(
                'Calendar-এ যুক্ত করুন',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.item,
    required this.onAddToCalendar,
  });

  final _CalendarEventItem item;
  final VoidCallback onAddToCalendar;

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('dd MMMM yyyy').format(item.date);
    final timeText = DateFormat('hh:mm a').format(item.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ProCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58,
              height: 64,
              decoration: BoxDecoration(
                color: item.isToday
                    ? RbcColors.accent
                    : RbcColors.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${item.date.day}',
                    style: const TextStyle(
                      color: RbcColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(item.date),
                    style: const TextStyle(
                      color: RbcColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (item.isToday) const _Tag(text: 'আজ'),
                      _Tag(text: item.source),
                      if (item.addedToCalendar) const _Tag(text: 'Calendar Added'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: RbcColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$dateText • $timeText',
                    style: TextStyle(
                      color: RbcColors.primary.withOpacity(.66),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: RbcColors.primary.withOpacity(.72),
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor:
                    item.addedToCalendar ? Colors.green : RbcColors.accent,
                foregroundColor:
                    item.addedToCalendar ? Colors.white : RbcColors.primary,
              ),
              onPressed: onAddToCalendar,
              icon: Icon(
                item.addedToCalendar
                    ? Icons.check_rounded
                    : Icons.event_available_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: RbcColors.primary.withOpacity(.07),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: RbcColors.primary,
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _EmptyEventView extends StatelessWidget {
  const _EmptyEventView();

  @override
  Widget build(BuildContext context) {
    return ProCard(
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            color: RbcColors.primary.withOpacity(.65),
            size: 46,
          ),
          const SizedBox(height: 10),
          const Text(
            'কোনো upcoming event পাওয়া যায়নি',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RbcColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorEventView extends StatelessWidget {
  const _ErrorEventView({
    required this.onRetry,
  });

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: RbcColors.primary,
            size: 42,
          ),
          const SizedBox(height: 10),
          const Text(
            'কোন তথ্য লোড করা যায়নি',
            style: TextStyle(
              color: RbcColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: RbcColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('আবার চেষ্টা করুন'),
          ),
        ],
      ),
    );
  }
}