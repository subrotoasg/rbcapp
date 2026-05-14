// import 'package:flutter/material.dart';
// import 'package:rbc_flutter_professional/core/config/app_config.dart';
// import 'package:rbc_flutter_professional/core/services/app_action_service.dart';
// import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
// import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
// import 'package:rbc_flutter_professional/shared/widgets/section_header.dart';

// class LinkToolsScreen extends StatelessWidget {
//   const LinkToolsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final items = [
//       _LinkItem(
//         title: 'আমাদের ওয়েবসাইট',
//         subtitle: 'ওয়েবসাইট খুলুন',
//         value: AppConfig.websiteUrl,
//         icon: Icons.language_rounded,
//         type: _LinkType.web,
//       ),
//       _LinkItem(
//         title: 'Facebook',
//         subtitle: 'আমাদের ফেসবুক গ্রুপ/পেজ দেখুন',
//         value: AppConfig.facebookGroup,
//         icon: Icons.facebook_rounded,
//         type: _LinkType.web,
//       ),
//       _LinkItem(
//         title: 'মোবাইল নম্বর',
//         subtitle: AppConfig.mobileNumber,
//         value: AppConfig.mobileNumber,
//         icon: Icons.call_rounded,
//         type: _LinkType.phone,
//       ),
//       _LinkItem(
//         title: 'ইমেইল',
//         subtitle: AppConfig.email,
//         value: AppConfig.email,
//         icon: Icons.email_rounded,
//         type: _LinkType.email,
//       ),
//      _LinkItem(
//         title: 'হোয়াটসঅ্যাপ গ্রুপ',
//         subtitle: 'আমাদের গ্রুপে যুক্ত হতে ক্লিক করুন',
//         value: AppConfig.whatsAppGroupLink,
//         icon: Icons.groups_rounded, 
//         type: _LinkType.whatsapp,
//       ),
//       _LinkItem(
//         title: 'Google Meet',
//         subtitle: 'মিটিং লিংক খুলুন বা তৈরি করুন',
//         value: AppConfig.googleMeetUrl,
//         icon: Icons.video_call_rounded,
//         type: _LinkType.web,
//       ),
//       _LinkItem(
//         title: 'Google Calendar',
//         subtitle: 'ক্যালেন্ডার খুলুন',
//         value: AppConfig.googleCalendarUrl,
//         icon: Icons.calendar_month_rounded,
//         type: _LinkType.web,
//       ),
//       _LinkItem(
//         title: 'YouTube',
//         subtitle: 'RBC/সনাতন/বাংলাদেশ কন্টেন্ট দেখুন',
//         value: AppConfig.youtubeUrl,
//         icon: Icons.play_circle_rounded,
//         type: _LinkType.web,
//       ),
//       _LinkItem(
//         title: 'বাংলাদেশ খেলা',
//         subtitle: 'লাইভ স্কোর ও আপডেট দেখুন',
//         value: AppConfig.bangladeshSportsUrl,
//         icon: Icons.sports_cricket_rounded,
//         type: _LinkType.web,
//       ),
//     ];

//    return Scaffold(
//       backgroundColor: const Color(0xffF5F7FA),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded),
//           onPressed: () => Navigator.of(context).maybePop(),
//         ),
//         title: const Text('প্রয়োজনীয় লিংক'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
//         children: [
//           ...items.map(
//             (item) => Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: ProCard(
//                 onTap: () => _openItem(context, item, insideApp: true),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: RbcColors.accent,
//                       foregroundColor: RbcColors.primary,
//                       child: Icon(item.icon),
//                     ),
//                     const SizedBox(width: 14),

//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             item.title,
//                             style: const TextStyle(
//                               color: RbcColors.primary,
//                               fontWeight: FontWeight.w900,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             item.subtitle,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: RbcColors.primary.withOpacity(.66),
//                               fontWeight: FontWeight.w600,
//                               height: 1.35,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     IconButton(
//                       tooltip: item.type == _LinkType.phone
//                           ? 'কল করুন'
//                           : item.type == _LinkType.email
//                               ? 'ইমেইল করুন'
//                               : 'বাইরে খুলুন',
//                       onPressed: () => _openItem(
//                         context,
//                         item,
//                         insideApp: false,
//                       ),
//                       icon: Icon(
//                         item.type == _LinkType.phone
//                             ? Icons.call_rounded
//                             : item.type == _LinkType.email
//                                 ? Icons.email_rounded
//                                 : Icons.open_in_new_rounded,
//                         color: RbcColors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static void _openItem(
//     BuildContext context,
//     _LinkItem item, {
//     required bool insideApp,
//   }) {
//     final url = item.actionUrl;

//     if (item.type == _LinkType.phone || 
//         item.type == _LinkType.email || 
//         item.type == _LinkType.whatsapp || 
//         item.type == _LinkType.meet
//          ) { 
//       AppActionService.openExternal(context, url);
//       return;
//     }

//     if (insideApp) {
//       AppActionService.openInsideApp(context, item.title, url);
//     } else {
//       AppActionService.openExternal(context, url);
//     }
//   }
// }

// enum _LinkType {
//   web,
//   phone,
//   email,
//   whatsapp,
//   meet,
// }

// class _LinkItem {
//   const _LinkItem({
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     required this.icon,
//     required this.type,
//   });

//   final String title;
//   final String subtitle;
//   final String value;
//   final IconData icon;
//   final _LinkType type;

//   String get actionUrl {
//     switch (type) {
//       case _LinkType.phone:
//         final cleanNumber = value.replaceAll(' ', '').replaceAll('-', '');
//         return 'tel:$cleanNumber';

//       case _LinkType.email:
//         return 'mailto:$value';

//       case _LinkType.web:
//       case _LinkType.whatsapp:
//       case _LinkType.meet:
//         return value;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/config/app_config.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/services/app_action_service.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';

class LinkToolsScreen extends StatefulWidget {
  const LinkToolsScreen({super.key});

  @override
  State<LinkToolsScreen> createState() => _LinkToolsScreenState();
}

class _LinkToolsScreenState extends State<LinkToolsScreen> {
  late Future<Map<String, dynamic>?> _meetFuture;

  @override
  void initState() {
    super.initState();
    _meetFuture = _fetchMeetData();
  }

  Future<Map<String, dynamic>?> _fetchMeetData() async {
    try {
      final response = await ApiClient.instance.get('/api/v1/google/meet');
      if (response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      debugPrint('Meet Data Fetch Error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('প্রয়োজনীয় লিংক'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _meetFuture,
        builder: (context, snapshot) {
          // ডেটা প্রসেসিং
          final data = snapshot.data;
          debugPrint('Meet Data: $data');
          final String meetTitle = data?['title'] ?? 'Google Meet';
          final String meetLink = data?['meetLink'] ?? AppConfig.googleMeetUrl;
          final String meetTime = data?['meetingTime'] != null
              ? "সময়: ${data?['meetingTime']} (${data?['meetingDate']})"
              : 'মিটিং লিংক খুলুন বা তৈরি করুন';

          // আইটেম লিস্ট তৈরি
          final items = [
            _LinkItem(
              title: 'আমাদের ওয়েবসাইট',
              subtitle: 'ওয়েবসাইট খুলুন',
              value: AppConfig.websiteUrl,
              icon: Icons.language_rounded,
              type: _LinkType.web,
            ),
            _LinkItem(
              title: 'Facebook গ্রুপ',
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
              title: 'হোয়াটসঅ্যাপ গ্রুপ',
              subtitle: 'আমাদের গ্রুপে যুক্ত হতে ক্লিক করুন',
              value: AppConfig.whatsAppGroupLink,
              icon: Icons.groups_rounded,
              type: _LinkType.whatsapp,
            ),
            _LinkItem(
              title: meetTitle,
              subtitle: meetTime,
              value: meetLink,
              icon: Icons.video_call_rounded,
              type: _LinkType.meet,
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

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
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
              );
            },
          );
        },
      ),
    );
  }

  static void _openItem(
    BuildContext context,
    _LinkItem item, {
    required bool insideApp,
  }) {
    final url = item.actionUrl;

    if (item.type == _LinkType.phone ||
        item.type == _LinkType.email ||
        item.type == _LinkType.whatsapp ||
        item.type == _LinkType.meet) {
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
  whatsapp,
  meet,
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
      case _LinkType.whatsapp:
      case _LinkType.meet:
        return value;
    }
  }
}