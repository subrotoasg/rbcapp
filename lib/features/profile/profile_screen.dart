import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/shared/widgets/app_network_image.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const pledges = [
    'আমি কোনো ব্যক্তিকে ব্যক্তিগত আঘাত করবো না।',
    'শুধুমাত্র কাদিরদী দাসপাড়ার সত্য ও গঠনমূলক ঘটনাগুলোই পোস্ট করবো।',
    'অপপ্রচার বা গুজব ছড়াবো না।',
    'প্রাসঙ্গিক ও সম্মানজনক ছবি শেয়ার করবো।',
    'Adult বা অনৈতিক ছবি শেয়ার করবো না।',
    'অশ্লীল ভাষা বা বিদ্বেষমূলক মন্তব্য করবো না।',
    'সকল ধর্ম, সংস্কৃতি ও ব্যক্তির প্রতি শ্রদ্ধাশীল থাকবো।',
    'এই প্ল্যাটফর্মকে সুস্থ ও তথ্যবহুল রাখার জন্য সচেষ্ট থাকবো।',
    'নীতিমালা এবং শর্তাবলী অবশ্যই মেনে চলবো।',
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    return Scaffold(
      appBar: AppBar(title: const Text('প্রোফাইল')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProCard(
            highlight: true,
            child: Row(
              children: [
                AppNetworkAvatar(url: user?.photo ?? '', size: 82),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'RBC User', style: const TextStyle(color: RbcColors.surface, fontWeight: FontWeight.w900, fontSize: 22)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? '', style: TextStyle(color: RbcColors.surface.withOpacity(.76), fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      const Text('#কাদিরদী #বোয়ালমারী #ফরিদপুর', style: TextStyle(color: RbcColors.accent, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ProCard(
            child: Row(
              children: [
                const Icon(Icons.lock_clock_rounded, color: RbcColors.primary, size: 34),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('লগইন সেশন', style: TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 17)),
                      const SizedBox(height: 4),
                      Text(
                        user == null ? 'সেশন তথ্য নেই' : 'মেয়াদ: ${DateFormat('dd MMMM yyyy').format(user.expiresAt)} পর্যন্ত',
                        style: TextStyle(color: RbcColors.primary.withOpacity(.70), fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ProCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('আমি শপথ করছি যে, এই অ্যাপ ব্যবহার করার সময়:', style: TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 14),
                for (final pledge in pledges)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.verified_rounded, color: RbcColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(pledge, style: TextStyle(color: RbcColors.primary.withOpacity(.86), height: 1.4))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
