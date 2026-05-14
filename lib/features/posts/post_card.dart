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

                      // Facebook Style Text Logic
                      final isLongText = text.length > 150 || '\n'.allMatches(text).length > 3;
                      final displayText = (isLongText && !expanded)
                      ? '${text.substring(0, 150).trim()}...'
                      : text;

                      return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProCard(
                      // ProCard এর ভেতরে ডিফল্ট প্যাডিং থাকলে তা রিমুভ করে নিজের মতো সাজাতে পারেন,
                      // আপাতত স্ট্যান্ডার্ড গ্যাপ রাখা হলো।
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      // --- HEADER (Profile Info) ---
                      Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      AppNetworkAvatar(
                      url: '${post['creatorImage'] ?? ''}',
                      size: 44,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                      '${post['creatorName'] ?? ''}',
                      style: const TextStyle(
                      color: RbcColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                      children: [
                      Text(
                      DateFormatter.bdt(post['date']),
                      style: TextStyle(
                      color: RbcColors.primary.withOpacity(.6),
                      fontSize: 12,
                      ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                      Icons.public,
                      size: 12,
                      color: RbcColors.primary.withOpacity(.6),
                      ),
                      ],
                      ),
                      ],
                      ),
                      ),
                      if (widget.canDelete)
                      IconButton(
                      onPressed: busy ? null : () => _delete(context),
                      icon: Icon(
                      Icons.more_horiz_rounded, // Facebook style 3-dots
                      color: RbcColors.primary.withOpacity(.7),
                      ),
                      ),
                      ],
                      ),

                      const SizedBox(height: 12),

                      // --- POST CAPTION ---
                      if (text.isNotEmpty) ...[
                      Text(
                      displayText,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                      color: RbcColors.primary,
                      fontSize: 15,
                      height: 1.4,
                      ),
                      ),
                      if (isLongText)
                GestureDetector(
                  onTap: () => setState(() => expanded = !expanded),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      expanded ? 'সংক্ষিপ্ত করুন' : 'আরও পড়ুন',
                      style: const TextStyle(
                        color: Color(0xFF0866FF), // ফেসবুকের অরিজিনাল ব্লু (Blue) কালার
                        fontWeight: FontWeight.w600, // সেমি-বোল্ড, যাতে একটু হাইলাইট হয়
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                      const SizedBox(height: 12),
                      ],

                      // --- POST IMAGE ---
                      if ('${post['image'] ?? ''}'.isNotEmpty) ...[
                      AppNetworkImage(
                      url: '${post['image']}',
                      height: 250, // একটু বড় করা হয়েছে প্রফেশনাল লুকের জন্য
                      width: double.infinity,
                      radius: 8, // Facebook এর ছবিগুলো সাধারণত চারকোনা বা সামান্য রাউন্ড হয়
                      ),
                      const SizedBox(height: 12),
                      ],

                      // --- LIKES & COMMENTS COUNTER ---
                      if (currentLikes.isNotEmpty || currentComments.isNotEmpty) ...[
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      if (currentLikes.isNotEmpty)
                      Row(
                      children: [
                      Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                      color: RbcColors.accent,
                      shape: BoxShape.circle,
                      ),
                      child: const Icon(
                      Icons.thumb_up_rounded,
                      size: 12,
                      color: Colors.white,
                      ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                      '${currentLikes.length}',
                      style: TextStyle(
                      color: RbcColors.primary.withOpacity(.7),
                      fontSize: 14,
                      ),
                      ),
                      ],
                      )
                      else
                      const SizedBox.shrink(),
                      if (currentComments.isNotEmpty)
                      Text(
                      '${currentComments.length} কমেন্ট',
                      style: TextStyle(
                      color: RbcColors.primary.withOpacity(.7),
                      fontSize: 14,
                      ),
                      ),
                      ],
                      ),
                      const SizedBox(height: 8),
                      Divider(height: 1, color: RbcColors.primary.withOpacity(.1)),
                      ],

                      // --- ACTION BUTTONS (LIKE / COMMENT) ---
                      Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                      children: [
                      Expanded(
                      child: InkWell(
                      onTap: busy ? null : () => _react(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(
                      liked
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_up_alt_outlined,
                      color: liked ? RbcColors.accent : RbcColors.primary.withOpacity(.7),
                      size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                      'লাইক',
                      style: TextStyle(
                      color: liked ? RbcColors.accent : RbcColors.primary.withOpacity(.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      ),
                      ),
                      ],
                      ),
                      ),
                      ),
                      ),
                      Expanded(
                      child: InkWell(
                      onTap: () => setState(() => showComment = !showComment),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(
                      Icons.mode_comment_outlined,
                      color: RbcColors.primary.withOpacity(.7),
                      size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                      'কমেন্ট',
                      style: TextStyle(
                      color: RbcColors.primary.withOpacity(.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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

                      if (currentLikes.isNotEmpty || currentComments.isNotEmpty)
                      Divider(height: 1, color: RbcColors.primary.withOpacity(.1)),

                      // --- COMMENTS SECTION ---
                      if (showComment) ...[
                      const SizedBox(height: 12),
                      for (final c in currentComments.take(5))
                      Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      AppNetworkAvatar(
                      url: '${c['photo'] ?? ''}',
                      size: 34,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Container(
                      padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                      ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                      '${c['comments'] ?? ''}'.replaceAll(
                      r'\n',
                      '\n',
                      ),
                      style: const TextStyle(fontSize: 14),
                      ),
                      ],
                      ),
                      ),
                      ],
                      ),
                      ),
                      ],
                      ),
                      ),

                      // Comment Input Field
                      Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      AppNetworkAvatar(
                      url: user?.photo ?? '',
                      size: 36,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                      child: TextField(
                      controller: comment,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                      hintText: 'আপনার মন্তব্য লিখুন...',
                      hintStyle: TextStyle(fontSize: 14, color: RbcColors.primary.withOpacity(.5)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      filled: true,
                      fillColor: RbcColors.primary.withOpacity(.05),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                      ),
                      ),
                      ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                      style: IconButton.styleFrom(
                      backgroundColor: RbcColors.primary.withOpacity(.05),
                      ),
                      onPressed: busy ? null : () => _comment(context),
                      icon: const Icon(
                      Icons.send_rounded,
                      color: RbcColors.primary,
                      size: 20,
                      ),
                      ),
                      ],
                      ),
                      ],
                      ],
                      ),
                      ),
                      );
                      }

                      // --- API Functions (_react, _comment, _delete) remain unchanged ---
                      // (আপনার আগের কোডের ফাংশনগুলো হুবহু এখানে থাকবে)

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
                            if (!mounted) return;
                            setState(() {
                            post['likes'] = oldLikes;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(ApiClient.messageFrom(e))),
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
                                SnackBar(content: Text(ApiClient.messageFrom(e))),
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

                                      setState(() {
                                      deleted = true;
                                      });

                                      widget.onChanged?.call();
                                      } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(ApiClient.messageFrom(e))),
                                      );
                                      } finally {
                                      if (mounted && !deleted) {
                                      setState(() => busy = false);
                                      }
                                      }
                                      }
                                      }