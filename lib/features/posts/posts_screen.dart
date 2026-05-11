import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/features/posts/post_api.dart';
import 'package:rbc_flutter_professional/features/posts/post_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<dynamic>> future;

  @override
  void initState() {
    super.initState();
    future = PostApi(ApiClient.instance).posts();
  }

  void reload() => setState(() => future = PostApi(ApiClient.instance).posts());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('পোস্ট সমূহ')),
      body: FutureBuilder<List<dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) return const EmptyView();
          return RefreshIndicator(
            onRefresh: () async => reload(),
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: posts.length,
              itemBuilder: (_, i) => PostCard(
                post: Map<String, dynamic>.from(posts[i] as Map),
                onChanged: reload,
              ),
            ),
          );
        },
      ),
    );
  }
}
