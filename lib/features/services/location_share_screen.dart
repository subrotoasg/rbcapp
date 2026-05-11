import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/services/app_action_service.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';

class LocationShareScreen extends StatelessWidget {
  const LocationShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('লাইভ লোকেশন')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProCard(
            highlight: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.share_location_rounded, color: RbcColors.accent, size: 42),
                const SizedBox(height: 14),
                const Text('লোকেশন শেয়ার ও ট্রেস', style: TextStyle(color: RbcColors.surface, fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('আপনার বর্তমান Google Maps লোকেশন WhatsApp, Messenger, SMS বা অন্য মাধ্যমে শেয়ার করতে পারবেন।', style: TextStyle(color: RbcColors.surface.withOpacity(.80), height: 1.45)),
                const SizedBox(height: 18),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: RbcColors.accent, foregroundColor: RbcColors.primary),
                  onPressed: () => AppActionService.shareCurrentLocation(context),
                  icon: const Icon(Icons.near_me_rounded),
                  label: const Text('আমার লোকেশন শেয়ার করুন'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ProCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('নিরাপত্তা নোট', style: TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 17)),
                const SizedBox(height: 8),
                Text('লোকেশন শুধুমাত্র আপনার অনুমতি দিলে নেওয়া হবে। কারও ব্যক্তিগত লোকেশন ট্রেস করতে হলে তার সম্মতি থাকা আবশ্যক।', style: TextStyle(color: RbcColors.primary.withOpacity(.75), height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
