import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background/login-background.png', fit: BoxFit.cover),
          Container(color: RbcColors.primary.withOpacity(.50)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: RbcColors.surface.withOpacity(.96),
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(color: RbcColors.accent, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: RbcColors.primary.withOpacity(.26),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          decoration: const BoxDecoration(color: RbcColors.primary, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: const Text('RBC', style: TextStyle(color: RbcColors.accent, fontWeight: FontWeight.w900, fontSize: 23)),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'রূপসী বাংলা ক্লাব',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: RbcColors.primary, fontWeight: FontWeight.w900, fontSize: 27),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'আমাদের গ্রামের সকল তথ্য এখন এক অ্যাপেই',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: RbcColors.primary.withOpacity(.74), fontSize: 14, height: 1.45, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 24),
                        Consumer<AuthController>(
                          builder: (context, auth, _) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: auth.isBusy
                                        ? null
                                        : () async {
                                            final ok = await auth.loginWithGoogle();
                                            if (!ok && context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(auth.error ?? 'লগইন করা যায়নি')),
                                              );
                                            }
                                          },
                                    icon: auth.isBusy
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: RbcColors.surface),
                                          )
                                        : const Icon(Icons.login_rounded),
                                    label: Text(auth.isBusy ? 'অপেক্ষা করুন...' : 'Google দিয়ে লগইন করুন'),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'পশ্চিম দাসপাড়া, কাদিরদী, বোয়ালমারী, ফরিদপুর',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: RbcColors.primary.withOpacity(.62), fontSize: 12, fontWeight: FontWeight.w800),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text('© Created By Subroto Das', style: TextStyle(color: RbcColors.surface.withOpacity(.88), fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
