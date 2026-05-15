import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/calculation/earn_list_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/month_cada_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/puja_pronami_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/spend_list_screen.dart';
import 'package:rbc_flutter_professional/features/festival/festival_list_screen.dart';
import 'package:rbc_flutter_professional/features/posts/posts_screen.dart';
import 'package:rbc_flutter_professional/features/posts/user_posts_screen.dart';
import 'package:rbc_flutter_professional/features/profile/profile_screen.dart';
import 'package:rbc_flutter_professional/features/services/about_rbc_screen.dart';
import 'package:rbc_flutter_professional/features/services/link_tools_screen.dart';
import 'package:rbc_flutter_professional/features/services/location_share_screen.dart';
import 'package:rbc_flutter_professional/features/services/panchika_screen.dart';
import 'package:rbc_flutter_professional/features/services/services_hub_screen.dart';
import 'package:rbc_flutter_professional/features/services/village_services_screen.dart';
import 'package:rbc_flutter_professional/shared/widgets/app_network_image.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.user;
    String firstLetter = 'R';
    if (user?.name != null && user!.name!.isNotEmpty) {
      firstLetter = user.name![0].toUpperCase();
    }
    return Drawer(
      backgroundColor: RbcColors.surface,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: RbcColors.primary,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  if (user?.photo != null && user!.photo!.isNotEmpty)
                    AppNetworkAvatar(url: user.photo!, size: 76)
                  else
                    Container(
                      height: 76,
                      width: 76,
                      decoration: const BoxDecoration(
                        color: RbcColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          firstLetter,
                          style: const TextStyle(
                            color: RbcColors.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  // AppNetworkAvatar(url: user?.photo ?? '', size: 76),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'RBC User',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: RbcColors.surface,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(color: RbcColors.surface.withOpacity(.78)),
                  ),
                ],
              ),
            ),
            _tile(context, Icons.dashboard_customize_rounded, 'সকল সেবা', const ServicesHubScreen()),
            _tile(context, Icons.info_rounded, 'ক্লাব পরিচিতি', const AboutRbcScreen()),
            _tile(context, Icons.temple_hindu_rounded, 'ক্যালেন্ডার ইভেন্ট', const PanchikaScreen()),
            _tile(context, Icons.volunteer_activism_rounded, 'গ্রাম সেবা', const VillageServicesScreen()),
            _tile(context, Icons.link_rounded, 'প্রয়োজনীয় লিংক', const LinkToolsScreen()),
            const Divider(color: RbcColors.primary),
            _tile(context, Icons.person_rounded, 'প্রোফাইল', const ProfileScreen()),
            _tile(context, Icons.my_library_books_rounded, 'আপনার পোস্ট', const UserPostsScreen()),
            _tile(context, Icons.dynamic_feed_rounded, 'সকলের পোস্ট', const PostsScreen()),
            _tile(context, Icons.event_rounded, 'আমাদের উৎসব', const FestivalListScreen()),
            _tile(context, Icons.payments_rounded, 'আয় হিসাব', const EarnListScreen()),
            _tile(context, Icons.receipt_long_rounded, 'ব্যয় হিসাব', const SpendListScreen()),
            _tile(context, Icons.account_balance_wallet_rounded, 'মাসিক চাঁদা', const MonthCadaScreen()),
            _tile(context, Icons.menu_book_rounded, 'পূজার প্রণামী', const PujaPronamiScreen()),
            const Divider(color: RbcColors.primary),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: RbcColors.primary),
              title: const Text('লগ আউট', style: TextStyle(fontWeight: FontWeight.w800)),
              onTap: () async {
                Navigator.pop(context);
                await context.read<AuthController>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: RbcColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: RbcColors.primary)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}
