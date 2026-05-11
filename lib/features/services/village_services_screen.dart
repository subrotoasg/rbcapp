import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/services/app_action_service.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/section_header.dart';

class VillageServicesScreen extends StatelessWidget {
  const VillageServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = const [
      _Service('স্বাস্থ্য ক্যাম্প', 'ফ্রি চিকিৎসা, রক্তদান, স্বাস্থ্য সচেতনতা ও জরুরি সহায়তা।', Icons.medical_services_rounded),
      _Service('শিক্ষা সহায়তা', 'শিক্ষা উপকরণ বিতরণ, মেধাবী শিক্ষার্থী সহায়তা ও দক্ষতা উন্নয়ন।', Icons.school_rounded),
      _Service('উন্নয়ন প্রজেক্ট', 'রাস্তা, আলো, পরিচ্ছন্নতা, পানি ও সামাজিক উন্নয়নমূলক কাজের তালিকা।', Icons.construction_rounded),
      _Service('সামাজিক সহায়তা', 'অসহায় মানুষের পাশে দাঁড়ানো, ত্রাণ, খাদ্য ও জরুরি সহযোগিতা।', Icons.volunteer_activism_rounded),
      _Service('ধর্মীয় অনুষ্ঠান', 'পূজা, পার্বণ, প্রসাদ, স্বেচ্ছাসেবক ও অনুষ্ঠান ব্যবস্থাপনা।', Icons.temple_hindu_rounded),
      _Service('খেলাধুলা', 'শারীরিক ও মানসিক সুস্থতার জন্য ক্রীড়া আয়োজন ও প্রতিযোগিতা।', Icons.sports_cricket_rounded),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('গ্রাম সেবা')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          ProCard(
            highlight: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('গ্রামের সব তথ্য এক জায়গায়', style: TextStyle(color: RbcColors.accent, fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('যেকোনো সেবা, উন্নয়ন, স্বাস্থ্য ও শিক্ষা কার্যক্রমের তথ্য', style: TextStyle(color: RbcColors.surface, height: 1.45)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: RbcColors.accent, foregroundColor: RbcColors.primary),
                      onPressed: () => AppActionService.openMap(context),
                      icon: const Icon(Icons.map_rounded),
                      label: const Text('গ্রাম ম্যাপ'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: RbcColors.surface, side: BorderSide(color: RbcColors.surface.withOpacity(.42))),
                      onPressed: () => AppActionService.shareCurrentLocation(context),
                      icon: const Icon(Icons.share_location_rounded),
                      label: const Text('লোকেশন শেয়ার'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...services.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(backgroundColor: RbcColors.accent, foregroundColor: RbcColors.primary, child: Icon(item.icon)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.title, style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 16)),
                          const SizedBox(height: 6),
                          Text(item.body, style: TextStyle(color: RbcColors.primary.withOpacity(.72), height: 1.4)),
                        ]),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _Service {
  const _Service(this.title, this.body, this.icon);
  final String title;
  final String body;
  final IconData icon;
}
