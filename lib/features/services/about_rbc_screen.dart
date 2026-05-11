import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/config/app_config.dart';
import 'package:rbc_flutter_professional/core/services/app_action_service.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/section_header.dart';

class AboutRbcScreen extends StatelessWidget {
  const AboutRbcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = const [
      _InfoSection(
        'আমাদের পরিচয়',
        'রূপসী বাংলা ক্লাব (RBC) সামাজিক, ধর্মীয়, শিক্ষা, স্বাস্থ্য ও উন্নয়নমূলক কার্যক্রমে সক্রিয়ভাবে জড়িত। মানুষের কল্যাণ ও সমাজের উন্নতির জন্য ক্লাবটি নিরলসভাবে কাজ করছে।',
        Icons.groups_rounded,
      ),
      _InfoSection(
        'সামাজিক কার্যক্রম',
        'প্রজেক্ট ভিত্তিক কার্যক্রমের মাধ্যমে স্থানীয় জনগণের মধ্যে সচেতনতা সৃষ্টি, সহায়তা প্রদান এবং সবার জন্য ন্যায্য সুযোগ তৈরিতে RBC কাজ করে।',
        Icons.handshake_rounded,
      ),
      _InfoSection(
        'ধর্মীয় কার্যক্রম',
        'ধর্মীয় ভাবনা, পরস্পরের প্রতি শ্রদ্ধাবোধ এবং সহযোগিতার ভিত্তিতে বিভিন্ন পূজা, অনুষ্ঠান ও শিক্ষা কার্যক্রম পরিচালিত হয়।',
        Icons.temple_hindu_rounded,
      ),
      _InfoSection(
        'শিক্ষা ও স্বাস্থ্য',
        'শিশুদের শিক্ষা উপকরণ বিতরণ, পড়াশোনায় আগ্রহ সৃষ্টি, স্বাস্থ্য ক্যাম্প ও বিনামূল্যে চিকিৎসা সেবার মাধ্যমে সমাজে স্বাস্থ্য সচেতনতা বাড়ানো হয়।',
        Icons.health_and_safety_rounded,
      ),
      _InfoSection(
        'প্রযুক্তি ও উন্নয়ন',
        'ওয়েবসাইট ও মোবাইল অ্যাপের মাধ্যমে ক্লাবের কার্যক্রম, হিসাব, পোস্ট, ইভেন্ট ও তথ্য মানুষের কাছে সহজে পৌঁছে দেওয়া হচ্ছে।',
        Icons.public_rounded,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('রূপসী বাংলা ক্লাব')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          ProCard(
            highlight: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RBC',
                  style: TextStyle(
                    color: RbcColors.accent,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'সমাজের উন্নয়ন, সেবা ও ঐক্যের ডিজিটাল প্ল্যাটফর্ম',
                  style: TextStyle(
                    color: RbcColors.surface,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'কাদিরদী • বোয়ালমারী • ফরিদপুর',
                  style: TextStyle(
                    color: RbcColors.surface.withOpacity(.76),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: RbcColors.accent,
                    foregroundColor: RbcColors.primary,
                  ),
                  onPressed: () => AppActionService.openInsideApp(context, 'RBC Website', AppConfig.websiteUrl),
                  icon: const Icon(Icons.language_rounded),
                  label: const Text('ওয়েবসাইট দেখুন'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'ক্লাবের কার্যক্রম', subtitle: 'প্রতিটি কাজ সমাজের কল্যাণে নিবেদিত'),
          const SizedBox(height: 12),
          ...sections.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: RbcColors.accent,
                        foregroundColor: RbcColors.primary,
                        child: Icon(item.icon),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: RbcColors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.body,
                              style: TextStyle(
                                color: RbcColors.primary.withOpacity(.76),
                                fontWeight: FontWeight.w700,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
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

class _InfoSection {
  const _InfoSection(this.title, this.body, this.icon);
  final String title;
  final String body;
  final IconData icon;
}
