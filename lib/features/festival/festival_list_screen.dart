import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/utils/date_formatter.dart';
import 'package:rbc_flutter_professional/features/festival/festival_api.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_table.dart';

class FestivalListScreen extends StatelessWidget {
  const FestivalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('উৎসব সমূহ')),
      body: FutureBuilder<List<dynamic>>(
        future: FestivalApi(ApiClient.instance).events(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
          final now = DateTime.now();
          final events = (snapshot.data ?? [])
              .where((e) {
                final d = DateTime.tryParse('${e['date'] ?? ''}');
                if (d == null) return false;
                return !d.isBefore(DateTime(now.year, now.month, now.day));
              })
              .toList()
            ..sort((a, b) => DateTime.parse('${a['date']}').compareTo(DateTime.parse('${b['date']}')));
          if (events.isEmpty) return const EmptyView();
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: events.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) return const ProTableHeader(columns: ['তারিখ', 'উৎসব', 'কত দিন পর']);
              final item = events[i - 1] as Map;
              return ProTableRow(values: [DateFormatter.simple(item['date']), item['subtitle'], DateFormatter.daysFromNow(item['date'])]);
            },
          );
        },
      ),
    );
  }
}
