import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/posts/post_api.dart';
import 'package:rbc_flutter_professional/features/posts/post_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';

class UserPostsScreen extends StatefulWidget {
  const UserPostsScreen({super.key});

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  Future<List<dynamic>>? future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    future ??= PostApi(ApiClient.instance).userPosts(context.read<AuthController>().user?.token ?? '');
  }

  void reload() => setState(() {
        future = PostApi(ApiClient.instance).userPosts(context.read<AuthController>().user?.token ?? '');
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('আপনার পোস্টসমূহ')),
      body: FutureBuilder<List<dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) return const EmptyView();
          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: posts.length,
            itemBuilder: (_, i) => PostCard(
              post: Map<String, dynamic>.from(posts[i] as Map),
              canDelete: true,
              onChanged: reload,
            ),
          );
        },
      ),
    );
  }
}
