import 'dart:async';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/shared/screens/in_app_webview_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppActionService {
  AppActionService._();

  static Future<void> openInsideApp(BuildContext context, String title, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      showMessage(context, 'লিংকটি সঠিক নয়');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InAppWebViewScreen(title: title, url: url)),
    );
  }

  static Future<void> openExternal(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      showMessage(context, 'লিংকটি খুলতে সমস্যা হচ্ছে');
      return;
    }
    final canOpen = await canLaunchUrl(uri);
    if (!canOpen) {
      showMessage(context, 'লিংকটি খুলতে সমস্যা হচ্ছে');
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> addToCalendar({
    required BuildContext context,
    required String title,
    required DateTime start,
    String? description,
    String? location,
  }) async {
    try {
      final event = Event(
        title: title,
        description: description ?? 'রূপসী বাংলা ক্লাব ইভেন্ট',
        location: location ?? 'কাদিরদী, বোয়ালমারী, ফরিদপুর',
        startDate: start,
        endDate: start.add(const Duration(hours: 2)),
      );
      final ok = await Add2Calendar.addEvent2Cal(event);
      if (context.mounted) {
        showMessage(context, ok ? 'ক্যালেন্ডারে যুক্ত করা হয়েছে' : 'ক্যালেন্ডারে যুক্ত করা যায়নি');
      }
    } catch (_) {
      if (context.mounted) showMessage(context, 'ক্যালেন্ডার খুলতে সমস্যা হচ্ছে');
    }
  }

  static Future<void> shareCurrentLocation(BuildContext context) async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        showMessage(context, 'লোকেশন সার্ভিস চালু করুন');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        showMessage(context, 'লোকেশন পারমিশন দিন');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );
      final url = 'https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}';
      await Share.share('আমার লাইভ লোকেশন: $url');
    } on TimeoutException {
      showMessage(context, 'লোকেশন পেতে সময় লাগছে। আবার চেষ্টা করুন।');
    } catch (_) {
      showMessage(context, 'লোকেশন শেয়ার করা যায়নি');
    }
  }

  static Future<void> openMap(BuildContext context, {String? query}) async {
    final url = query == null || query.isEmpty
        ? 'https://www.google.com/maps/search/?api=1&query=Kadirdi+Boalmari+Faridpur'
        : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}';
    await openExternal(context, url);
  }

  static void showMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: RbcColors.primary,
        content: Text(message),
      ),
    );
  }
}
