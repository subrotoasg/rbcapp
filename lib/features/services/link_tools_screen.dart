import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/config/app_config.dart';
import 'package:rbc_flutter_professional/core/services/app_action_service.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/section_header.dart';

class LinkToolsScreen extends StatelessWidget {
  const LinkToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _LinkItem(
        title: 'RBC Website',
        subtitle: 'ওয়েবসাইট অ্যাপের ভিতরে দেখুন',
        value: AppConfig.websiteUrl,
        icon: Icons.language_rounded,
        type: _LinkType.web,
      ),
      _LinkItem(
        title: 'Facebook',
        subtitle: 'আমাদের ফেসবুক গ্রুপ/পেজ দেখুন',
        value: AppConfig.facebookGroup,
        icon: Icons.facebook_rounded,
        type: _LinkType.web,
      ),
      _LinkItem(
        title: 'মোবাইল নম্বর',
        subtitle: AppConfig.mobileNumber,
        value: AppConfig.mobileNumber,
        icon: Icons.call_rounded,
        type: _LinkType.phone,
      ),
      _LinkItem(
        title: 'ইমেইল',
        subtitle: AppConfig.email,
        value: AppConfig.email,
        icon: Icons.email_rounded,
        type: _LinkType.email,
      ),
      _LinkItem(
        title: 'Google Meet',
        subtitle: 'মিটিং লিংক খুলুন বা তৈরি করুন',
        value: AppConfig.googleMeetUrl,
        icon: Icons.video_call_rounded,
        type: _LinkType.web,
      ),
      _LinkItem(
        title: 'Google Calendar',
        subtitle: 'ক্যালেন্ডার খুলুন',
        value: AppConfig.googleCalendarUrl,
        icon: Icons.calendar_month_rounded,
        type: _LinkType.web,
      ),
      _LinkItem(
        title: 'YouTube',
        subtitle: 'RBC/সনাতন/বাংলাদেশ কন্টেন্ট দেখুন',
        value: AppConfig.youtubeUrl,
        icon: Icons.play_circle_rounded,
        type: _LinkType.web,
      ),
      _LinkItem(
        title: 'বাংলাদেশ খেলা',
        subtitle: 'লাইভ স্কোর ও আপডেট দেখুন',
        value: AppConfig.bangladeshSportsUrl,
        icon: Icons.sports_cricket_rounded,
        type: _LinkType.web,
      ),
    ];

   return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('প্রয়োজনীয় লিংক'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProCard(
                onTap: () => _openItem(context, item, insideApp: true),
                child: Row(
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
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: RbcColors.primary.withOpacity(.66),
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      tooltip: item.type == _LinkType.phone
                          ? 'কল করুন'
                          : item.type == _LinkType.email
                              ? 'ইমেইল করুন'
                              : 'বাইরে খুলুন',
                      onPressed: () => _openItem(
                        context,
                        item,
                        insideApp: false,
                      ),
                      icon: Icon(
                        item.type == _LinkType.phone
                            ? Icons.call_rounded
                            : item.type == _LinkType.email
                                ? Icons.email_rounded
                                : Icons.open_in_new_rounded,
                        color: RbcColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _openItem(
    BuildContext context,
    _LinkItem item, {
    required bool insideApp,
  }) {
    final url = item.actionUrl;

    if (item.type == _LinkType.phone || item.type == _LinkType.email) {
      AppActionService.openExternal(context, url);
      return;
    }

    if (insideApp) {
      AppActionService.openInsideApp(context, item.title, url);
    } else {
      AppActionService.openExternal(context, url);
    }
  }
}

enum _LinkType {
  web,
  phone,
  email,
}

class _LinkItem {
  const _LinkItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.type,
  });

  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final _LinkType type;

  String get actionUrl {
    switch (type) {
      case _LinkType.phone:
        final cleanNumber = value.replaceAll(' ', '').replaceAll('-', '');
        return 'tel:$cleanNumber';

      case _LinkType.email:
        return 'mailto:$value';

      case _LinkType.web:
        return value;
    }
  }
}