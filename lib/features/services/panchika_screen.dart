import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/section_header.dart';

class PanchikaScreen extends StatefulWidget {
  const PanchikaScreen({super.key});

  @override
  State<PanchikaScreen> createState() => _PanchikaScreenState();
}

class _PanchikaScreenState extends State<PanchikaScreen> {
  final DeviceCalendarPlugin _calendarPlugin = DeviceCalendarPlugin();

  late Future<List<PhoneCalendarEvent>> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = _loadUpcomingEvents();
  }

  Future<void> _refresh() async {
    setState(() {
      eventsFuture = _loadUpcomingEvents();
    });

    await eventsFuture;
  }

  Future<List<PhoneCalendarEvent>> _loadUpcomingEvents() async {
    final hasPermissionResult = await _calendarPlugin.hasPermissions();
    final hasPermission = hasPermissionResult.data == true;

    if (!hasPermission) {
      final permissionResult = await _calendarPlugin.requestPermissions();

      if (permissionResult.data != true) {
        throw CalendarPermissionException();
      }
    }

    final calendarsResult = await _calendarPlugin.retrieveCalendars();
    final calendars = calendarsResult.data ?? [];

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final endDate = todayStart.add(const Duration(days: 370));

    final allEvents = <PhoneCalendarEvent>[];

    for (final calendar in calendars) {
      final calendarId = calendar.id;

      if (calendarId == null || calendarId.isEmpty) continue;

      final result = await _calendarPlugin.retrieveEvents(
        calendarId,
        RetrieveEventsParams(
          startDate: todayStart,
          endDate: endDate,
        ),
      );

      final events = result.data ?? [];

      for (final event in events) {
        final start = event.start;

        if (start == null) continue;

        final startDate = DateTime(
          start.year,
          start.month,
          start.day,
          start.hour,
          start.minute,
        );

        final eventDayStart = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
        );

        if (eventDayStart.isBefore(todayStart)) continue;

        final end = event.end;

        allEvents.add(
          PhoneCalendarEvent(
            id: event.eventId ?? '',
            title: _cleanText(event.title, fallback: 'নামবিহীন ইভেন্ট'),
            description: _cleanText(event.description),
            location: _cleanText(event.location),
            calendarName: _cleanText(
              calendar.name,
              fallback: 'Calendar',
            ),
            start: startDate,
            end: end == null
                ? null
                : DateTime(
                    end.year,
                    end.month,
                    end.day,
                    end.hour,
                    end.minute,
                  ),
            isAllDay: event.allDay ?? false,
          ),
        );
      }
    }

    allEvents.sort((a, b) => a.start.compareTo(b.start));

    return allEvents;
  }

  static String _cleanText(String? value, {String fallback = ''}) {
    final text = '${value ?? ''}'.trim();
    return text.isEmpty ? fallback : text;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('ক্যালেন্ডার ইভেন্ট'),
      ),
      body: RefreshIndicator(
        color: RbcColors.primary,
        onRefresh: _refresh,
        child: FutureBuilder<List<PhoneCalendarEvent>>(
          future: eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            }

            if (snapshot.hasError) {
              final permissionError =
                  snapshot.error is CalendarPermissionException;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _ErrorCard(
                    title: permissionError
                        ? 'Calendar permission দরকার'
                        : 'ইভেন্ট লোড করা যায়নি',
                    message: permissionError
                        ? 'আপনার ফোনের Calendar events দেখানোর জন্য permission allow করুন।'
                        : 'Calendar data পড়তে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
                    onRetry: _refresh,
                  ),
                ],
              );
            }

            final events = snapshot.data ?? [];
            final todayEvents = events.where((e) => e.isToday).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                _TodayCard(
                  today: today,
                  todayCount: todayEvents.length,
                  totalEvents: events.length,
                ),

                const SizedBox(height: 22),

                const SectionHeader(
                  title: 'আজ ও আসন্ন ইভেন্ট',
                  subtitle: '',
                ),

                const SizedBox(height: 12),

                if (events.isEmpty)
                  const _EmptyCalendarCard()
                else
                  ..._buildGroupedEvents(events),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildGroupedEvents(List<PhoneCalendarEvent> events) {
    final widgets = <Widget>[];
    DateTime? lastDate;

    for (final event in events) {
      final eventDate = DateTime(
        event.start.year,
        event.start.month,
        event.start.day,
      );

      final shouldShowHeader = lastDate == null ||
          lastDate.year != eventDate.year ||
          lastDate.month != eventDate.month ||
          lastDate.day != eventDate.day;

      if (shouldShowHeader) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 10),
            child: _DateGroupHeader(date: eventDate),
          ),
        );
        lastDate = eventDate;
      }

      widgets.add(_CalendarEventCard(event: event));
    }

    return widgets;
  }
}

class PhoneCalendarEvent {
  const PhoneCalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.calendarName,
    required this.start,
    required this.end,
    required this.isAllDay,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final String calendarName;
  final DateTime start;
  final DateTime? end;
  final bool isAllDay;

  bool get isToday {
    final now = DateTime.now();

    return start.year == now.year &&
        start.month == now.month &&
        start.day == now.day;
  }
}

class CalendarPermissionException implements Exception {}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.today,
    required this.todayCount,
    required this.totalEvents,
  });

  final DateTime today;
  final int todayCount;
  final int totalEvents;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      highlight: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'আজকের ক্যালেন্ডার',
            style: TextStyle(
              color: RbcColors.accent,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat('EEEE, dd MMMM yyyy').format(today),
            style: const TextStyle(
              color: RbcColors.surface,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroChip(
                icon: Icons.today_rounded,
                text: 'আজ $todayCount টি',
              ),
              _HeroChip(
                icon: Icons.event_available_rounded,
                text: 'Upcoming $totalEvents টি',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white.withOpacity(.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: RbcColors.surface,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: RbcColors.surface,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateGroupHeader extends StatelessWidget {
  const _DateGroupHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);

    final title = itemDate == today
        ? 'আজ'
        : DateFormat('EEEE, dd MMMM yyyy').format(date);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: RbcColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          width: 44,
          height: 3,
          decoration: BoxDecoration(
            color: RbcColors.accent,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ],
    );
  }
}

class _CalendarEventCard extends StatelessWidget {
  const _CalendarEventCard({
    required this.event,
  });

  final PhoneCalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('dd MMMM yyyy').format(event.start);
    final timeText = event.isAllDay
        ? 'সারাদিন'
        : DateFormat('hh:mm a').format(event.start);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ProCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 64,
              decoration: BoxDecoration(
                color: event.isToday
                    ? RbcColors.accent
                    : RbcColors.primary.withOpacity(.07),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${event.start.day}',
                    style: const TextStyle(
                      color: RbcColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(event.start),
                    style: TextStyle(
                      color: RbcColors.primary.withOpacity(.72),
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
                  if (event.isToday)
                    Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: RbcColors.accent.withOpacity(.22),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'আজ',
                        style: TextStyle(
                          color: RbcColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),

                  Text(
                    event.title,
                    style: const TextStyle(
                      color: RbcColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '$dateText • $timeText',
                    style: TextStyle(
                      color: RbcColors.primary.withOpacity(.66),
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 15,
                        color: RbcColors.primary.withOpacity(.48),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          event.calendarName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: RbcColors.primary.withOpacity(.55),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (event.location.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: RbcColors.primary.withOpacity(.48),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            event.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: RbcColors.primary.withOpacity(.55),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (event.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: RbcColors.primary.withOpacity(.70),
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCalendarCard extends StatelessWidget {
  const _EmptyCalendarCard();

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
            'কোনো upcoming calendar event পাওয়া যায়নি',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RbcColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Google Calendar বা ফোনের Calendar sync করা থাকলে events এখানে দেখাবে।',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RbcColors.primary.withOpacity(.62),
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      child: Column(
        children: [
          Icon(
            Icons.lock_clock_rounded,
            color: RbcColors.primary.withOpacity(.72),
            size: 48,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: RbcColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RbcColors.primary.withOpacity(.68),
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
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