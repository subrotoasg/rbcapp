import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/home/home_api.dart';
import 'package:rbc_flutter_professional/features/home/widgets/banner_carousel.dart';
import 'package:rbc_flutter_professional/features/posts/post_api.dart';
import 'package:rbc_flutter_professional/shared/widgets/app_network_image.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController text = TextEditingController();

  late final Future<List<dynamic>> bannerFuture;

  XFile? image;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    bannerFuture = HomeApi(ApiClient.instance).bottomBanners();
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  bool get canPost => text.text.trim().isNotEmpty || image != null;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('পোস্ট তৈরি করুন'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: RbcColors.primary.withOpacity(.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: RbcColors.accent,
                              width: 2,
                            ),
                          ),
                          child: AppNetworkAvatar(
                            url: user?.photo ?? '',
                            size: 50,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'RBC User',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: RbcColors.primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.public_rounded,
                                    size: 15,
                                    color: RbcColors.primary.withOpacity(.55),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'পাবলিক পোস্ট',
                                    style: TextStyle(
                                      color: RbcColors.primary.withOpacity(.55),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: RbcColors.primary.withOpacity(.07),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                    child: TextField(
                      controller: text,
                      minLines: 6,
                      maxLines: 12,
                      textInputAction: TextInputAction.newline,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                        color: RbcColors.primary,
                        fontSize: 17,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'আপনার মনের কথা লিখুন...',
                        hintStyle: TextStyle(
                          color: RbcColors.primary.withOpacity(.35),
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  if (image != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Stack(
                        children: [
                          Container(
                            height: 280,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xffF0F2F5),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: RbcColors.primary.withOpacity(.06),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: InkWell(
                              onTap: busy
                                  ? null
                                  : () {
                                      setState(() => image = null);
                                    },
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.55),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.35),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xffF8FAFC),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: RbcColors.primary.withOpacity(.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ComposerAction(
                              icon: Icons.photo_library_rounded,
                              label: 'গ্যালারী',
                              onTap: busy
                                  ? null
                                  : () => _pick(ImageSource.gallery),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ComposerAction(
                              icon: Icons.camera_alt_rounded,
                              label: 'ক্যামেরা',
                              onTap: busy
                                  ? null
                                  : () => _pick(ImageSource.camera),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _PostRulesCard(
              canPost: canPost,
              busy: busy,
              onPost: _submit,
            ),

            const SizedBox(height: 22),

            BannerCarousel(
              future: bannerFuture,
              height: 110,
              borderRadius: 24,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(ImageSource source) async {
    if (busy) return;

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() => image = picked);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiClient.messageFrom(e)),
        ),
      );
    }
  }

  Future<void> _submit() async {
    final user = context.read<AuthController>().user;
    if (user == null) return;

    final postText = text.text.trim();

    if (postText.isEmpty && image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('পোস্ট করার জন্য কিছু লিখুন অথবা একটি ছবি যোগ করুন'),
        ),
      );
      return;
    }

    setState(() => busy = true);

    try {
      final api = PostApi(ApiClient.instance);

      String? imageUrl;

      if (image != null) {
        imageUrl = await api.uploadToImgBb(image!.path);
      }

      await api.createPost({
        'post': postText.replaceAll('\n', r'\n'),
        'image': imageUrl,
        'creatorName': user.name,
        'creatorImage': user.photo,
      }, user.token);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiClient.messageFrom(e)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => busy = false);
      }
    }
  }
}

class _PostRulesCard extends StatelessWidget {
  const _PostRulesCard({
    required this.canPost,
    required this.busy,
    required this.onPost,
  });

  final bool canPost;
  final bool busy;
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    final buttonEnabled = canPost && !busy;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: RbcColors.primary.withOpacity(.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.045),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: RbcColors.accent.withOpacity(.22),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: RbcColors.primary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'আমি প্রতিজ্ঞা করছিঃ',
                  style: TextStyle(
                    color: RbcColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const _RuleItem(
            text:
                'অশ্লীল, কুরুচিপূর্ণ, অশালীন বা অপমানজনক কোনো লেখা/ছবি পোস্ট করছি না।',
          ),
          const _RuleItem(
            text:
                'কোনো ব্যক্তি, পরিবার, ধর্ম, জাতি, সংগঠন বা সম্প্রদায়কে টার্গেট করে পোস্ট করছি না।',
          ),
          const _RuleItem(
            text:
                'মিথ্যা, গুজব, রাজনৈতিক উসকানি, হুমকি বা বিভ্রান্তিকর তথ্য পোস্ট করছি না।',
          ),
          const _RuleItem(
            text:
                'ব্যক্তিগত তথ্য, ফোন নম্বর, ছবি বা অনুমতি ছাড়া কারো তথ্য প্রকাশ করছি না।',
          ),
          const _RuleItem(
            text:
                'শুধু গ্রাম, ক্লাব, সামাজিক উন্নয়ন, প্রয়োজনীয় তথ্য ও ইতিবাচক বিষয় পোস্ট করছি।',
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xffFFF7ED),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xffF59E0B).withOpacity(.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xffB45309),
                  size: 21,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'আমি যদি নিয়ম ভঙ্গ করে কোনো পোস্ট করি, তবে সম্পূর্ণ দায়ভার আমার নিজের।',
                    style: TextStyle(
                      color: const Color(0xff7C2D12).withOpacity(.90),
                      fontWeight: FontWeight.w800,
                      height: 1.38,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 64,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: buttonEnabled
                    ? RbcColors.primary
                    : RbcColors.primary.withOpacity(.30),
                disabledBackgroundColor: RbcColors.primary.withOpacity(.30),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withOpacity(.72),
                elevation: buttonEnabled ? 7 : 0,
                shadowColor: RbcColors.primary.withOpacity(.35),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: buttonEnabled
                        ? RbcColors.accent.withOpacity(.75)
                        : Colors.transparent,
                    width: 1.2,
                  ),
                ),
              ),
              onPressed: buttonEnabled ? onPost : null,
              child: busy
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.3,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'পোস্ট হচ্ছে...',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.5,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.16),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(.18),
                            ),
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 11),
                        const Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'প্রতিজ্ঞা মেনে পোস্ট করুন',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.5,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'আমি উপরের নিয়ম মেনেই পোস্ট করছি',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.5,
                                  height: 1.1,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          if (!canPost) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'পোস্ট করতে কিছু লিখুন অথবা একটি ছবি যোগ করুন',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: RbcColors.primary.withOpacity(.55),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(top: 7),
            decoration: const BoxDecoration(
              color: RbcColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: RbcColors.primary.withOpacity(.76),
                fontWeight: FontWeight.w700,
                height: 1.38,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  const _ComposerAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: disabled ? .45 : 1,
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: RbcColors.primary.withOpacity(.08),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: RbcColors.primary.withOpacity(.82),
                size: 21,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: RbcColors.primary.withOpacity(.86),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}