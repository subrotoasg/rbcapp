import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/services/notification_service.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/festival/festival_list_screen.dart';
import 'package:rbc_flutter_professional/features/home/home_screen.dart';
import 'package:rbc_flutter_professional/features/posts/add_post_screen.dart';
import 'package:rbc_flutter_professional/features/posts/posts_screen.dart';
import 'package:rbc_flutter_professional/features/profile/profile_screen.dart';
import 'package:rbc_flutter_professional/features/services/services_hub_screen.dart';
import 'package:rbc_flutter_professional/features/shell/app_drawer.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    ServicesHubScreen(),
    PostsScreen(),
    FestivalListScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthController>().user;
      if (user != null) NotificationService.instance.registerDevice(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['RBC', 'সেবা', 'পোস্ট', 'ইভেন্ট', 'প্রোফাইল'];
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          IconButton(
            tooltip: 'নতুন পোস্ট',
            onPressed: () => _open(const AddPostScreen()),
            icon: const Icon(Icons.add_photo_alternate_rounded),
          ),
          IconButton(
            tooltip: 'সেবা',
            onPressed: () => setState(() => _index = 1),
            icon: const Icon(Icons.dashboard_customize_rounded),
          ),
        ],
      ),
      floatingActionButton: _index == 2
          ? FloatingActionButton.extended(
              backgroundColor: RbcColors.accent,
              foregroundColor: RbcColors.primary,
              onPressed: () => _open(const AddPostScreen()),
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: const Text('পোস্ট'),
            )
          : null,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        backgroundColor: RbcColors.primary,
        indicatorColor: RbcColors.accent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded, color: RbcColors.surface),
            selectedIcon: Icon(Icons.home_rounded, color: RbcColors.primary),
            label: 'হোম',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize_rounded, color: RbcColors.surface),
            selectedIcon: Icon(Icons.dashboard_customize_rounded, color: RbcColors.primary),
            label: 'সেবা',
          ),
          NavigationDestination(
            icon: Icon(Icons.dynamic_feed_rounded, color: RbcColors.surface),
            selectedIcon: Icon(Icons.dynamic_feed_rounded, color: RbcColors.primary),
            label: 'পোস্ট',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_rounded, color: RbcColors.surface),
            selectedIcon: Icon(Icons.event_rounded, color: RbcColors.primary),
            label: 'ইভেন্ট',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded, color: RbcColors.surface),
            selectedIcon: Icon(Icons.person_rounded, color: RbcColors.primary),
            label: 'প্রোফাইল',
          ),
        ],
      ),
    );
  }

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}
