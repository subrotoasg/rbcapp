
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:rbc_flutter_professional/core/services/api_client.dart';
// import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
// import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
// import 'package:rbc_flutter_professional/features/home/home_api.dart';
// import 'package:rbc_flutter_professional/features/home/widgets/banner_carousel.dart';
// import 'package:rbc_flutter_professional/features/posts/post_api.dart';
// import 'package:rbc_flutter_professional/shared/widgets/app_network_image.dart';

// class AddPostScreen extends StatefulWidget {
//   const AddPostScreen({super.key});

//   @override
//   State<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends State<AddPostScreen> {
//   final TextEditingController text = TextEditingController();

//   late final Future<List<dynamic>> bannerFuture;

//   XFile? image;
//   bool busy = false;

//   @override
//   void initState() {
//     super.initState();
//     bannerFuture = HomeApi(ApiClient.instance).bottomBanners();
//   }

//   @override
//   void dispose() {
//     text.dispose();
//     super.dispose();
//   }

//   bool get canPost => text.text.trim().isNotEmpty || image != null;

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<AuthController>().user;

//     return Scaffold(
//       backgroundColor: const Color(0xffF5F7FA),
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         foregroundColor: RbcColors.primary,
//         title: const Text(
//           'পোস্ট তৈরি করুন',
//           style: TextStyle(
//             fontWeight: FontWeight.w900,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(28),
//                 border: Border.all(
//                   color: RbcColors.primary.withOpacity(.06),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(.06),
//                     blurRadius: 26,
//                     offset: const Offset(0, 12),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(18),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(2),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: RbcColors.accent,
//                               width: 2,
//                             ),
//                           ),
//                           child: AppNetworkAvatar(
//                             url: user?.photo ?? '',
//                             size: 50,
//                           ),
//                         ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 user?.name ?? 'RBC User',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   color: RbcColors.primary,
//                                   fontWeight: FontWeight.w900,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.public_rounded,
//                                     size: 15,
//                                     color: RbcColors.primary.withOpacity(.55),
//                                   ),
//                                   const SizedBox(width: 5),
//                                   Text(
//                                     'পাবলিক পোস্ট',
//                                     style: TextStyle(
//                                       color: RbcColors.primary.withOpacity(.55),
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   Divider(
//                     height: 1,
//                     color: RbcColors.primary.withOpacity(.07),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
//                     child: TextField(
//                       controller: text,
//                       minLines: 6,
//                       maxLines: 12,
//                       textInputAction: TextInputAction.newline,
//                       onChanged: (_) => setState(() {}),
//                       style: const TextStyle(
//                         color: RbcColors.primary,
//                         fontSize: 17,
//                         height: 1.45,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       decoration: InputDecoration(
//                         hintText: 'আপনার মনের কথা লিখুন...',
//                         hintStyle: TextStyle(
//                           color: RbcColors.primary.withOpacity(.35),
//                           fontWeight: FontWeight.w600,
//                           fontSize: 17,
//                         ),
//                         border: InputBorder.none,
//                         enabledBorder: InputBorder.none,
//                         focusedBorder: InputBorder.none,
//                         contentPadding: EdgeInsets.zero,
//                       ),
//                     ),
//                   ),

//                   if (image != null)
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
//                       child: Stack(
//                         children: [
//                           Container(
//                             height: 280,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: const Color(0xffF0F2F5),
//                               borderRadius: BorderRadius.circular(24),
//                               border: Border.all(
//                                 color: RbcColors.primary.withOpacity(.06),
//                               ),
//                             ),
//                             clipBehavior: Clip.antiAlias,
//                             child: Image.file(
//                               File(image!.path),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Positioned(
//                             top: 12,
//                             right: 12,
//                             child: InkWell(
//                               onTap: busy
//                                   ? null
//                                   : () {
//                                       setState(() => image = null);
//                                     },
//                               borderRadius: BorderRadius.circular(100),
//                               child: Container(
//                                 width: 38,
//                                 height: 38,
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(.55),
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Colors.white.withOpacity(.35),
//                                   ),
//                                 ),
//                                 child: const Icon(
//                                   Icons.close_rounded,
//                                   color: Colors.white,
//                                   size: 22,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: const Color(0xffF8FAFC),
//                         borderRadius: BorderRadius.circular(22),
//                         border: Border.all(
//                           color: RbcColors.primary.withOpacity(.06),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: _ComposerAction(
//                               icon: Icons.photo_library_rounded,
//                               label: 'গ্যালারী',
//                               onTap: busy ? null : () => _pick(ImageSource.gallery),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: _ComposerAction(
//                               icon: Icons.camera_alt_rounded,
//                               label: 'ক্যামেরা',
//                               onTap: busy ? null : () => _pick(ImageSource.camera),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 54,
//                       child: FilledButton(
//                         style: FilledButton.styleFrom(
//                           backgroundColor: RbcColors.primary,
//                           disabledBackgroundColor:
//                               RbcColors.primary.withOpacity(.30),
//                           foregroundColor: Colors.white,
//                           disabledForegroundColor: Colors.white.withOpacity(.75),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(18),
//                           ),
//                         ),
//                         onPressed: busy || !canPost ? null : _submit,
//                         child: busy
//                             ? const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 19,
//                                     height: 19,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2.2,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Text(
//                                     'পোস্ট হচ্ছে...',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w900,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.send_rounded, size: 20),
//                                   SizedBox(width: 9),
//                                   Text(
//                                     'পোস্ট করুন',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w900,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 22),

//             BannerCarousel(
//               future: bannerFuture,
//               height: 110,
//               borderRadius: 24,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pick(ImageSource source) async {
//     if (busy) return;

//     try {
//       final picked = await ImagePicker().pickImage(
//         source: source,
//         imageQuality: 85,
//       );

//       if (picked != null) {
//         setState(() => image = picked);
//       }
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(ApiClient.messageFrom(e)),
//         ),
//       );
//     }
//   }

//   Future<void> _submit() async {
//     final user = context.read<AuthController>().user;
//     if (user == null) return;

//     final postText = text.text.trim();

//     if (postText.isEmpty && image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('পোস্ট করার জন্য কিছু লিখুন অথবা একটি ছবি যোগ করুন'),
//         ),
//       );
//       return;
//     }

//     setState(() => busy = true);

//     try {
//       final api = PostApi(ApiClient.instance);

//       String? imageUrl;

//       if (image != null) {
//         imageUrl = await api.uploadToImgBb(image!.path);
//       }

//       await api.createPost({
//         'post': postText.replaceAll('\n', r'\n'),
//         'image': imageUrl,
//         'creatorName': user.name,
//         'creatorImage': user.photo,
//       }, user.token);

//       if (!mounted) return;

//       Navigator.pop(context, true);
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(ApiClient.messageFrom(e)),
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => busy = false);
//       }
//     }
//   }
// }

// class _ComposerAction extends StatelessWidget {
//   const _ComposerAction({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final disabled = onTap == null;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(17),
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 180),
//         opacity: disabled ? .45 : 1,
//         child: Container(
//           height: 46,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(17),
//             border: Border.all(
//               color: RbcColors.primary.withOpacity(.08),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 color: RbcColors.primary.withOpacity(.82),
//                 size: 21,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: RbcColors.primary.withOpacity(.86),
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
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

                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: RbcColors.primary,
                          disabledBackgroundColor:
                              RbcColors.primary.withOpacity(.30),
                          foregroundColor: Colors.white,
                          disabledForegroundColor:
                              Colors.white.withOpacity(.75),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: busy || !canPost ? null : _submit,
                        child: busy
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 19,
                                    height: 19,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'পোস্ট হচ্ছে...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded, size: 20),
                                  SizedBox(width: 9),
                                  Text(
                                    'পোস্ট করুন',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
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