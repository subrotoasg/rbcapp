import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/calculation/calculation_api.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_table.dart';

class PujaPronamiScreen extends StatelessWidget {
  const PujaPronamiScreen({super.key, this.embed = false});
  final bool embed;

  @override
  Widget build(BuildContext context) {
    final body = FutureBuilder<List<dynamic>>(
      future: CalculationApi(ApiClient.instance).pujaPronami(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
        final data = snapshot.data ?? [];
        if (data.isEmpty) return const EmptyView();
        return FutureBuilder<String>(
          future: CalculationApi(ApiClient.instance).pujaPronamiTitle(),
          builder: (context, titleSnap) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: embed ? 96 : 24),
              itemCount: data.length + 2,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: RbcColors.accent, borderRadius: BorderRadius.circular(18)),
                    child: Text(titleSnap.data ?? 'পূজার প্রণামী', textAlign: TextAlign.center, style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900)),
                  );
                }
                if (i == 1) return const ProTableHeader(columns: ['নাম', 'ধার্যকৃত অর্থ', 'প্রদানকৃত অর্থ']);
                final item = data[i - 2] as Map;
                return ProTableRow(values: [item['name'], item['fixedTk'], item['paidTk']]);
              },
            );
          },
        );
      },
    );
    if (embed) return body;
    return Scaffold(appBar: AppBar(title: const Text('পূজার প্রণামী')), body: body);
  }
}
