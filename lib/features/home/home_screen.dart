import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/home/home_api.dart';
import 'package:rbc_flutter_professional/features/home/widgets/banner_carousel.dart';
import 'package:rbc_flutter_professional/features/home/widgets/category_grid.dart';
import 'package:rbc_flutter_professional/features/posts/add_post_screen.dart';
import 'package:rbc_flutter_professional/features/posts/post_api.dart';
import 'package:rbc_flutter_professional/features/posts/post_card.dart';
import 'package:rbc_flutter_professional/features/posts/posts_screen.dart';
import 'package:rbc_flutter_professional/features/profile/profile_screen.dart';
import 'package:rbc_flutter_professional/features/services/services_hub_screen.dart';
import 'package:rbc_flutter_professional/shared/widgets/app_network_image.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeApi api;

  late Future<List<dynamic>> topBannersFuture;
  late Future<List<dynamic>> bannersFuture;
  late Future<List<dynamic>> postsFuture;

  @override
  void initState() {
    super.initState();

    api = HomeApi(ApiClient.instance);

    topBannersFuture = api.topBanners();
    bannersFuture = api.banners();
    postsFuture = PostApi(ApiClient.instance).posts();
  }

  Future<void> _refreshPosts() async {
    final future = PostApi(ApiClient.instance).posts();

    setState(() {
      postsFuture = future;
    });

    try {
      await future;
    } catch (_) {}
  }

  Future<void> _openAddPost() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddPostScreen(),
      ),
    );

    if (changed == true) {
      await _refreshPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;

    return RefreshIndicator(
      color: RbcColors.primary,
      onRefresh: _refreshPosts,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          ProCard(
            highlight: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      ),
                      child: AppNetworkAvatar(
                        url: user?.photo ?? '',
                        size: 58,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'RBC User',
                            style: const TextStyle(
                              color: RbcColors.surface,
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            'কাদিরদী, বোয়ালমারী, ফরিদপুর',
                            style: TextStyle(
                              color: RbcColors.surface.withOpacity(.72),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: RbcColors.accent,
                        foregroundColor: RbcColors.primary,
                      ),
                      onPressed: _openAddPost,
                      icon: const Icon(Icons.add_photo_alternate_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'রূপসী বাংলা ক্লাব',
                  style: TextStyle(
                    color: RbcColors.accent,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'সামাজিক, ধর্মীয়, শিক্ষা, স্বাস্থ্য ও উন্নয়নমূলক কার্যক্রমের স্মার্ট প্লাটফর্ম',
                  style: TextStyle(
                    color: RbcColors.surface.withOpacity(.82),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: RbcColors.accent,
                    foregroundColor: RbcColors.primary,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ServicesHubScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.dashboard_customize_rounded),
                  label: const Text('সব ফিচার দেখুন'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          BannerCarousel(
            future: topBannersFuture,
            height: 110,
            borderRadius: 24,
          ),

          const SizedBox(height: 22),

          const SizedBox(height: 12),

          const CategoryGrid(),

          const SizedBox(height: 18),

          BannerCarousel(
            future: bannersFuture,
            height: 180,
            borderRadius: 24,
          ),

          const SizedBox(height: 18),

          const SizedBox(height: 20),

          SectionHeader(
            title: 'সাম্প্রতিক পোস্ট',
            subtitle: 'গ্রাম ও ক্লাবের আপডেট',
            actionText: 'সব দেখুন',
            onAction: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PostsScreen(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          FutureBuilder<List<dynamic>>(
            future: postsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingView();
              }

              if (snapshot.hasError) {
                return EmptyView(
                  message: ApiClient.messageFrom(snapshot.error!),
                );
              }

              final posts = (snapshot.data ?? []).take(4).toList();

              if (posts.isEmpty) return const EmptyView();

              return Column(
                children: posts
                    .map(
                      (e) => PostCard(
                        post: e as Map<String, dynamic>,
                        onChanged: _refreshPosts,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}