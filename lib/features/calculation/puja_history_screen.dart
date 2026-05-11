import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/calculation/calculation_api.dart';
import 'package:rbc_flutter_professional/features/calculation/puja_details_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/puja_utils.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';

class PujaHistoryScreen extends StatelessWidget {
  const PujaHistoryScreen({super.key, required this.category, required this.title});
  final String category;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<dynamic>>(
        future: CalculationApi(ApiClient.instance).pujaParbon(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
          final data = (snapshot.data ?? []).where((e) => '${e['catagory'] ?? ''}' == category).toList();
          if (data.isEmpty) return const EmptyView();
          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: data.length,
            itemBuilder: (_, i) {
              final item = Map<String, dynamic>.from(data[i] as Map);
              final calc = PujaMath.calculate(item);
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PujaDetailsScreen(item: item))),
                  child: ProCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('শ্রী শ্রী ${item['title'] ?? ''} ${item['selectYear'] ?? ''} ইং সাল', style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 16)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _mini('আয়', calc['totalIncome'])),
                            const SizedBox(width: 10),
                            Expanded(child: _mini('ব্যয়', calc['totalSpend'])),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('বিস্তারিত →', style: TextStyle(color: RbcColors.primary.withOpacity(.8), fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _mini(String label, dynamic amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RbcColors.primary.withOpacity(.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('$label: $amount/-', textAlign: TextAlign.center, style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900)),
    );
  }
}
