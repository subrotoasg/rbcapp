// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rbc_flutter_professional/core/services/api_client.dart';
// import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
// import 'package:rbc_flutter_professional/core/utils/date_formatter.dart';
// import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
// import 'package:rbc_flutter_professional/features/posts/post_api.dart';
// import 'package:rbc_flutter_professional/shared/widgets/app_network_image.dart';
// import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';

// class PostCard extends StatefulWidget {
//   const PostCard({super.key, required this.post, this.canDelete = false, this.onChanged});
//   final Map<String, dynamic> post;
//   final bool canDelete;
//   final VoidCallback? onChanged;

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   bool expanded = false;
//   bool showComment = false;
//   final comment = TextEditingController();
//   bool busy = false;

//   @override
//   void dispose() {
//     comment.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthController>();
//     final user = auth.user;
//     final comments = widget.post['comments'] is List ? widget.post['comments'] as List : [];
//     final likes = widget.post['likes'] is List ? widget.post['likes'] as List : [];
//     final liked = likes.contains(user?.email);
//     final text = '${widget.post['post'] ?? ''}'.replaceAll(r'\n', '\n');

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: ProCard(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 AppNetworkAvatar(url: '${widget.post['creatorImage'] ?? ''}', size: 42),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '${widget.post['creatorName'] ?? ''}',
//                         style: const TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900),
//                       ),
//                       Text(
//                         DateFormatter.bdt(widget.post['date']),
//                         style: TextStyle(color: RbcColors.primary.withOpacity(.6), fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (widget.canDelete)
//                   IconButton(
//                     onPressed: () => _delete(context),
//                     icon: const Icon(Icons.delete_outline_rounded, color: RbcColors.primary),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text(
//               text,
//               maxLines: expanded ? null : 3,
//               overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
//               textAlign: TextAlign.justify,
//               style: TextStyle(color: RbcColors.primary.withOpacity(.9), height: 1.45),
//             ),
//             if (text.length > 120)
//               TextButton(
//                 onPressed: () => setState(() => expanded = !expanded),
//                 child: Text(expanded ? 'আবার কমিয়ে পড়ুন' : 'আরও পড়ুন'),
//               ),
//             if ('${widget.post['image'] ?? ''}'.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               AppNetworkImage(url: '${widget.post['image']}', height: 220, width: double.infinity, radius: 20),
//             ],
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () => _react(context),
//                   icon: Icon(
//                     liked ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
//                     color: RbcColors.primary,
//                   ),
//                 ),
//                 Text('${likes.length} লাইক', style: const TextStyle(color: RbcColors.primary)),
//                 const Spacer(),
//                 IconButton(
//                   onPressed: () => setState(() => showComment = !showComment),
//                   icon: const Icon(Icons.mode_comment_outlined, color: RbcColors.primary),
//                 ),
//                 Text('${comments.length} কমেন্ট', style: const TextStyle(color: RbcColors.primary)),
//               ],
//             ),
//             if (showComment) ...[
//               const SizedBox(height: 8),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppNetworkAvatar(url: user?.photo ?? '', size: 34),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: TextField(
//                       controller: comment,
//                       minLines: 1,
//                       maxLines: 3,
//                       decoration: const InputDecoration(hintText: 'আপনার মন্তব্য লিখুন'),
//                     ),
//                   ),
//                   IconButton.filled(
//                     style: IconButton.styleFrom(backgroundColor: RbcColors.primary),
//                     onPressed: busy ? null : () => _comment(context),
//                     icon: const Icon(Icons.send_rounded, color: RbcColors.surface),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               for (final c in comments.take(5))
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppNetworkAvatar(url: '${c['photo'] ?? ''}', size: 30),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: RbcColors.primary.withOpacity(.06),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('${c['name'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w900)),
//                               Text('${c['comments'] ?? ''}'.replaceAll(r'\n', '\n')),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _react(BuildContext context) async {
//     final user = context.read<AuthController>().user;
//     if (user == null) return;
//     await PostApi(ApiClient.instance).reaction({
//       'postId': widget.post['_id'],
//       'email': user.email,
//     }, user.token);
//     widget.onChanged?.call();
//   }

//   Future<void> _comment(BuildContext context) async {
//     final user = context.read<AuthController>().user;
//     if (user == null || comment.text.trim().isEmpty) return;
//     setState(() => busy = true);
//     await PostApi(ApiClient.instance).comment({
//       'postId': widget.post['_id'],
//       'comments': comment.text.trim().replaceAll('\n', r'\n'),
//       'email': user.email,
//       'name': user.name,
//       'photo': user.photo,
//     }, user.token);
//     comment.clear();
//     setState(() => busy = false);
//     widget.onChanged?.call();
//   }

//   Future<void> _delete(BuildContext context) async {
//     final user = context.read<AuthController>().user;
//     if (user == null) return;
//     final yes = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('আপনি কি নিশ্চিত?'),
//         content: const Text('এই পোস্টটি মুছে ফেলতে চান?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('না')),
//           FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('হ্যাঁ')),
//         ],
//       ),
//     );
//     if (yes != true) return;
//     await PostApi(ApiClient.instance).deletePost('${widget.post['_id']}', user.token);
//     widget.onChanged?.call();
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/core/utils/date_formatter.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/posts/post_api.dart';
import 'package:rbc_flutter_professional/shared/widgets/app_network_image.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    this.canDelete = false,
    this.onChanged,
  });

  final Map<String, dynamic> post;
  final bool canDelete;
  final VoidCallback? onChanged;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Map<String, dynamic> post;

  bool expanded = false;
  bool showComment = false;
  bool busy = false;
  bool deleted = false;

  final comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    post = Map<String, dynamic>.from(widget.post);
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.post['_id'] != widget.post['_id']) {
      post = Map<String, dynamic>.from(widget.post);
      expanded = false;
      showComment = false;
      busy = false;
      deleted = false;
    }
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  List<dynamic> get comments {
    return post['comments'] is List ? List<dynamic>.from(post['comments']) : [];
  }

  List<dynamic> get likes {
    return post['likes'] is List ? List<dynamic>.from(post['likes']) : [];
  }

  @override
  Widget build(BuildContext context) {
    if (deleted) return const SizedBox.shrink();

    final auth = context.watch<AuthController>();
    final user = auth.user;

    final currentComments = comments;
    final currentLikes = likes;
    final liked = currentLikes.contains(user?.email);
    final text = '${post['post'] ?? ''}'.replaceAll(r'\n', '\n');

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ProCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppNetworkAvatar(
                  url: '${post['creatorImage'] ?? ''}',
                  size: 42,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${post['creatorName'] ?? ''}',
                        style: const TextStyle(
                          color: RbcColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        DateFormatter.bdt(post['date']),
                        style: TextStyle(
                          color: RbcColors.primary.withOpacity(.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.canDelete)
                  IconButton(
                    onPressed: busy ? null : () => _delete(context),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: RbcColors.primary,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              text,
              maxLines: expanded ? null : 3,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: RbcColors.primary.withOpacity(.9),
                height: 1.45,
              ),
            ),

            if (text.length > 120)
              TextButton(
                onPressed: () => setState(() => expanded = !expanded),
                child: Text(expanded ? 'আবার কমিয়ে পড়ুন' : 'আরও পড়ুন'),
              ),

            if ('${post['image'] ?? ''}'.isNotEmpty) ...[
              const SizedBox(height: 8),
              AppNetworkImage(
                url: '${post['image']}',
                height: 220,
                width: double.infinity,
                radius: 20,
              ),
            ],

            const SizedBox(height: 12),

            Row(
              children: [
                IconButton(
                  onPressed: busy ? null : () => _react(context),
                  icon: Icon(
                    liked
                        ? Icons.thumb_up_alt_rounded
                        : Icons.thumb_up_alt_outlined,
                    color: liked ? RbcColors.accent : RbcColors.primary,
                  ),
                ),
                Text(
                  '${currentLikes.length} লাইক',
                  style: const TextStyle(color: RbcColors.primary),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => setState(() => showComment = !showComment),
                  icon: const Icon(
                    Icons.mode_comment_outlined,
                    color: RbcColors.primary,
                  ),
                ),
                Text(
                  '${currentComments.length} কমেন্ট',
                  style: const TextStyle(color: RbcColors.primary),
                ),
              ],
            ),

            if (showComment) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppNetworkAvatar(
                    url: user?.photo ?? '',
                    size: 34,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: comment,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'আপনার মন্তব্য লিখুন',
                      ),
                    ),
                  ),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: RbcColors.primary,
                    ),
                    onPressed: busy ? null : () => _comment(context),
                    icon: const Icon(
                      Icons.send_rounded,
                      color: RbcColors.surface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              for (final c in currentComments.take(5))
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppNetworkAvatar(
                        url: '${c['photo'] ?? ''}',
                        size: 30,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: RbcColors.primary.withOpacity(.06),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${c['name'] ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                '${c['comments'] ?? ''}'.replaceAll(
                                  r'\n',
                                  '\n',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _react(BuildContext context) async {
    final user = context.read<AuthController>().user;
    if (user == null || busy) return;

    final oldLikes = likes;
    final newLikes = List<dynamic>.from(oldLikes);

    if (newLikes.contains(user.email)) {
      newLikes.remove(user.email);
    } else {
      newLikes.add(user.email);
    }

    // সঙ্গে সঙ্গে UI update
    setState(() {
      post['likes'] = newLikes;
      busy = true;
    });

    try {
      await PostApi(ApiClient.instance).reaction({
        'postId': post['_id'],
        'email': user.email,
      }, user.token);

      widget.onChanged?.call();
    } catch (e) {
      // Error হলে আগের অবস্থায় ফিরিয়ে দিবে
      if (!mounted) return;

      setState(() {
        post['likes'] = oldLikes;
      });

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

  Future<void> _comment(BuildContext context) async {
    final user = context.read<AuthController>().user;
    final text = comment.text.trim();

    if (user == null || text.isEmpty || busy) return;

    final oldComments = comments;

    final newComment = {
      'comments': text.replaceAll('\n', r'\n'),
      'email': user.email,
      'name': user.name,
      'photo': user.photo,
    };

    final newComments = [
      newComment,
      ...oldComments,
    ];

    comment.clear();

    // সঙ্গে সঙ্গে UI update
    setState(() {
      post['comments'] = newComments;
      busy = true;
      showComment = true;
    });

    try {
      await PostApi(ApiClient.instance).comment({
        'postId': post['_id'],
        'comments': text.replaceAll('\n', r'\n'),
        'email': user.email,
        'name': user.name,
        'photo': user.photo,
      }, user.token);

      widget.onChanged?.call();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        post['comments'] = oldComments;
      });

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

  Future<void> _delete(BuildContext context) async {
    final user = context.read<AuthController>().user;
    if (user == null || busy) return;

    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('আপনি কি নিশ্চিত?'),
        content: const Text('এই পোস্টটি মুছে ফেলতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('না'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('হ্যাঁ'),
          ),
        ],
      ),
    );

    if (yes != true) return;

    setState(() => busy = true);

    try {
      await PostApi(ApiClient.instance).deletePost(
        '${post['_id']}',
        user.token,
      );

      if (!mounted) return;

      // delete করার পর সঙ্গে সঙ্গে card hide হবে
      setState(() {
        deleted = true;
      });

      widget.onChanged?.call();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiClient.messageFrom(e)),
        ),
      );
    } finally {
      if (mounted && !deleted) {
        setState(() => busy = false);
      }
    }
  }
}