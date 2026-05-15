// import 'package:flutter/material.dart';
// import 'package:rbc_flutter_professional/core/services/api_client.dart';
// import 'package:rbc_flutter_professional/core/utils/date_formatter.dart';
// import 'package:rbc_flutter_professional/features/festival/festival_api.dart';
// import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
// import 'package:rbc_flutter_professional/shared/widgets/pro_table.dart';

// class FestivalListScreen extends StatelessWidget {
// const FestivalListScreen({super.key});

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(title: const Text('উৎসব সমূহ')),
// body: FutureBuilder<List<dynamic>>(
  // future: FestivalApi(ApiClient.instance).events(),
  // builder: (context, snapshot) {
  // if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
  // final now = DateTime.now();
  // final events = (snapshot.data ?? [])
  // .where((e) {
  // final d = DateTime.tryParse('${e['date'] ?? ''}');
  // if (d == null) return false;
  // return !d.isBefore(DateTime(now.year, now.month, now.day));
  // })
  // .toList()
  // ..sort((a, b) => DateTime.parse('${a['date']}').compareTo(DateTime.parse('${b['date']}')));
  // if (events.isEmpty) return const EmptyView();
  // return ListView.builder(
  // padding: const EdgeInsets.only(bottom: 24),
  // itemCount: events.length + 1,
  // itemBuilder: (_, i) {
  // if (i == 0) return const ProTableHeader(columns: ['তারিখ', 'উৎসব', 'কত দিন পর']);
  // final item = events[i - 1] as Map;
  // return ProTableRow(values: [DateFormatter.simple(item['date']), item['title'], DateFormatter.daysFromNow(item['date'])]);
  // },
  // );
  // },
  // ),
  // );
  // }
  // }


  import 'package:flutter/material.dart';
  import 'package:rbc_flutter_professional/core/services/api_client.dart';
  import 'package:rbc_flutter_professional/core/utils/date_formatter.dart';
  import 'package:rbc_flutter_professional/features/festival/festival_api.dart';
  import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';

  class FestivalListScreen extends StatelessWidget {
  const FestivalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  backgroundColor: Colors.grey[100],
  appBar: AppBar(
  title: const Text('উৎসব সমূহ'),
  elevation: 0,
  ),
  body: FutureBuilder<List<dynamic>>(
    future: FestivalApi(ApiClient.instance).events(),
    builder: (context, snapshot) {
    // লোডিং অবস্থা
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const LoadingView();
    }

    // এরর হ্যান্ডলিং বা ডাটা না থাকলে
    if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
    return const Center(child: Text('কোনো তথ্য পাওয়া যায়নি'));
    }

    // ডাটা ফিল্টারিং এবং সর্টিং
    final now = DateTime.now();
    final events = snapshot.data!.where((e) {
    final d = DateTime.tryParse('${e['date'] ?? ''}');
    if (d == null) return false;
    return !d.isBefore(DateTime(now.year, now.month, now.day));
    }).toList()
    ..sort((a, b) => DateTime.parse('${a['date']}').compareTo(DateTime.parse('${b['date']}')));

    if (events.isEmpty) {
    return const Center(child: Text('সামনে কোনো উৎসব নেই'));
    }

    return ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 12),
    itemCount: events.length,
    itemBuilder: (_, i) {
    final item = events[i] as Map;

    // API কী অনুযায়ী ডেটা সেট করুন
    final String title = item['title'] ?? 'শিরোনামহীন';
    final String subtitle = item['subtitle'] ?? item['description'] ?? 'বিস্তারিত তথ্য নেই';
    final String dateStr = item['date'] ?? '';

    return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 1,
    child: ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    // বাম পাশের আইকন
    leading: Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: Theme.of(context).primaryColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(Icons.festival_outlined, color: Theme.of(context).primaryColor),
    ),

    // শিরোনাম
    title: Text(
    title,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    ),
    ),

    // সাবটাইটেল বা বিবরণ
    subtitle: Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
    subtitle,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(color: Colors.grey[600]),
    ),
    ),

    // ... trailing এর ভেতরে Column অংশটি এভাবে আপডেট করুন

    trailing: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    Text(
    DateFormatter.simple(dateStr),
    style: const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13,
    ),
    ),
    const SizedBox(height: 4),
    Builder(
    builder: (context) {
    // লজিক: তারিখের পার্থক্য বের করা
    final eventDate = DateTime.parse(dateStr);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(eventDate.year, eventDate.month, eventDate.day);

    final difference = target.difference(today).inDays;

    String displayText;
    if (difference == 0) {
    displayText = 'আজ';
    } else if (difference == 1) {
    displayText = 'আগামীকাল';
    } else {
    displayText = '${DateFormatter.daysFromNow(dateStr)} পর';
    }

    return Text(
    displayText,
    style: const TextStyle(
    color: Colors.deepOrange,
    fontSize: 11,
    fontWeight: FontWeight.bold,
    ),
    );
    },
    ),
    ],
    ),
    ),
    );
    },
    );
    },
    ),
    );
    }
    }