import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/calculation/calculation_api.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';

class IncomeByCategoryScreen extends StatelessWidget {
  const IncomeByCategoryScreen({super.key, required this.category, required this.title});
  final String category;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<dynamic>>(
        future: CalculationApi(ApiClient.instance).earns(''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
          final data = (snapshot.data ?? []).where((e) => '${e['type'] ?? ''}'.toLowerCase() == category.toLowerCase()).toList();
          if (data.isEmpty) return const EmptyView();
          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: data.length,
            itemBuilder: (_, i) {
              final item = data[i] as Map;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item['earnDetails'] ?? ''}', style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('প্রদানকারী: ${item['senderName'] ?? ''}', style: TextStyle(color: RbcColors.primary.withOpacity(.72))),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: Text('তারিখ: ${item['earnDate'] ?? ''}', style: const TextStyle(color: RbcColors.primary))),
                          Text('${item['earnValue'] ?? 0}৳', style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 18)),
                        ],
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
