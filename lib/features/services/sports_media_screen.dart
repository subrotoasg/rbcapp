import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/config/app_config.dart';
import 'package:rbc_flutter_professional/core/services/app_action_service.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/section_header.dart';

class SportsMediaScreen extends StatelessWidget {
  const SportsMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Media('বাংলাদেশ ক্রিকেট লাইভ স্কোর', 'স্কোর, সময়সূচি ও আপডেট', AppConfig.bangladeshSportsUrl, Icons.sports_cricket_rounded),
      _Media('বাংলাদেশ ফুটবল আপডেট', 'ম্যাচ ও খবর', 'https://www.google.com/search?q=Bangladesh+football+live+score', Icons.sports_soccer_rounded),
      _Media('RBC YouTube Search', 'ক্লাব ও গ্রামের ভিডিও কন্টেন্ট', AppConfig.youtubeUrl, Icons.play_circle_rounded),
      _Media('সনাতন ধর্মীয় ভিডিও', 'ভজন, আরতি, পূজা ও ধর্মীয় আলোচনা', 'https://www.youtube.com/results?search_query=sanatan+dharma+bangla+bhajan+puja', Icons.video_library_rounded),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('খেলা ও মিডিয়া')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          const SectionHeader(title: 'বাংলাদেশ খেলা ও YouTube', subtitle: 'অ্যাপের ভিতরে দ্রুত কন্টেন্ট দেখুন'),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProCard(
                  onTap: () => AppActionService.openInsideApp(context, item.title, item.url),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: RbcColors.accent, foregroundColor: RbcColors.primary, child: Icon(item.icon)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.title, style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(item.subtitle, style: TextStyle(color: RbcColors.primary.withOpacity(.66))),
                        ]),
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: RbcColors.primary),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _Media {
  const _Media(this.title, this.subtitle, this.url, this.icon);
  final String title;
  final String subtitle;
  final String url;
  final IconData icon;
}
