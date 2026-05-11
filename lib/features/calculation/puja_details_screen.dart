import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/calculation/puja_utils.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';

class PujaDetailsScreen extends StatelessWidget {
  const PujaDetailsScreen({super.key, required this.item});
  final Map<String, dynamic> item;

  static const incomeLabels = {
    'vPronami': 'গ্রামের প্রণামী',
    'totalGift': 'অতিথীদের অর্থ',
    'govtGift': 'সরকারী অর্থ',
  };
  static const spendLabels = {
    'protima': 'প্রতিমা বাবদ',
    'birammon': 'ব্রাম্নাণ বাবদ',
    'spendPuja': 'পূজা বাবদ',
    'prosadh': 'প্রসাধ বাবদ',
    'decoration': 'ডেকোরেশন বাবদ',
    'boxLight': 'বক্সলাইট বাবদ',
    'ancher': 'আনসার বাবদ',
    'otherSpand': 'অন্যান্য বাবদ',
  };

  @override
  Widget build(BuildContext context) {
    final calc = PujaMath.calculate(item);
    final pronami = PujaMath.extractPronami(item['pronami']);
    return Scaffold(
      appBar: AppBar(title: const Text('হিসাবের বিস্তারিত')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Row(
            children: [
              Expanded(child: _summary('মোট আয়', calc['totalIncome'])),
              const SizedBox(width: 10),
              Expanded(child: _summary('মোট ব্যয়', calc['totalSpend'])),
            ],
          ),
          const SizedBox(height: 10),
          _summary(calc['dueOrExtra']! >= 0 ? 'অতিরিক্ত অর্থ' : 'ব্যয় বেশি', calc['dueOrExtra']!.abs()),
          const SizedBox(height: 14),
          _details('আয়ের বিবরণ', item['income'], incomeLabels),
          const SizedBox(height: 14),
          _details('ব্যয়ের বিবরণ', item['spend'], spendLabels),
          if (pronami.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text('গ্রাম প্রণামীর তালিকা', textAlign: TextAlign.center, style: TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 10),
            for (final p in pronami)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ProCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(child: Text('${p['name']}', style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w800))),
                      Text('${p['amount']} টাকা', style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _summary(String label, dynamic amount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RbcColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: RbcColors.surface, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('$amount টাকা', style: const TextStyle(color: RbcColors.accent, fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _details(String title, dynamic arr, Map<String, String> labels) {
    final list = arr is List ? arr : [];
    return ProCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 12),
          for (final item in list)
            if (item is Map && item.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(labels['${item.keys.first}'] ?? '${item.keys.first}', style: TextStyle(color: RbcColors.primary.withOpacity(.8)))),
                    Text('${item.values.first} টাকা', style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
