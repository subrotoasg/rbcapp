import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/calculation/dues_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/earn_list_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/month_cada_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/puja_pronami_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/spend_list_screen.dart';
import 'package:rbc_flutter_professional/features/services/about_rbc_screen.dart';
import 'package:rbc_flutter_professional/features/services/event_hub_screen.dart';
import 'package:rbc_flutter_professional/features/services/link_tools_screen.dart';
import 'package:rbc_flutter_professional/features/services/location_share_screen.dart';
import 'package:rbc_flutter_professional/features/services/panchika_screen.dart';
import 'package:rbc_flutter_professional/features/services/sports_media_screen.dart';
import 'package:rbc_flutter_professional/features/services/village_services_screen.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
import 'package:rbc_flutter_professional/screens/village_people_list_screen.dart';

class ServicesHubScreen extends StatelessWidget {
  const ServicesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _HubItem('ক্লাব পরিচিতি', 'ক্লাবের লক্ষ্য ও কার্যক্রম', Icons.info_rounded, const AboutRbcScreen()),
      _HubItem('গ্রাম সদস্য', 'গ্রামের বংশতালিকা ও তথ্য', Icons.family_restroom_rounded, const VillagePeopleListScreen()),
      _HubItem('আয় হিসাব', 'ক্লাবের আয় তালিকা', Icons.payments_rounded, const EarnListScreen()),
      _HubItem('ব্যয় হিসাব', 'ব্যয়ের তালিকা', Icons.receipt_long_rounded, const SpendListScreen()),
      _HubItem('মাসিক চাঁদা', 'সদস্য চাঁদা', Icons.account_balance_wallet_rounded, const MonthCadaScreen()),
      _HubItem('পূজার প্রণামী', 'অনুদান ও হিসাব', Icons.menu_book_rounded, const PujaPronamiScreen()),
      _HubItem('বকেয়া অর্থ', 'দেয়া/বকেয়া', Icons.warning_amber_rounded, const DuesScreen()),
      _HubItem('গ্রাম সেবা', 'স্বাস্থ্য, শিক্ষা, উন্নয়ন', Icons.volunteer_activism_rounded, const VillageServicesScreen()),
      _HubItem('আমাদের উৎসব', 'Calendar-এ যুক্ত করুন', Icons.event_available_rounded, const EventHubScreen()),
      _HubItem('ক্যালেন্ডার', 'উৎসব অনুষ্ঠান', Icons.temple_hindu_rounded, const PanchikaScreen()),
      _HubItem('লিংক ও টুলস', 'Meet, YouTube, Website', Icons.link_rounded, const LinkToolsScreen()),
    
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('সকল সার্ভিস'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          // ProCard(
          //   highlight: true,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         'সব সার্ভিস একসাথে',
          //         style: TextStyle(
          //           color: RbcColors.accent,
          //           fontSize: 22,
          //           fontWeight: FontWeight.w900,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       Text(
          //         'শিক্ষা, সাংস্কৃতিক, ধর্মীয় কার্যক্রম এবং হিসাব সবকিছু এক অ্যাপে।',
          //         style: TextStyle(
          //           color: RbcColors.surface.withOpacity(.82),
          //           height: 1.45,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // const SizedBox(height: 22),

          GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: .98,
            ),
            itemBuilder: (context, index) {
              final item = items[index];

              return ProCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => item.screen,
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: RbcColors.accent,
                      foregroundColor: RbcColors.primary,
                      child: Icon(item.icon),
                    ),
                    const Spacer(),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: RbcColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: RbcColors.primary.withOpacity(.64),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HubItem {
  const _HubItem(this.title, this.subtitle, this.icon, this.screen);

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget screen;
}