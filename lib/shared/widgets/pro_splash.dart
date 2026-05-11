import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';

class ProSplashScreen extends StatefulWidget {
  const ProSplashScreen({super.key});

  @override
  State<ProSplashScreen> createState() => _ProSplashScreenState();
}

class _ProSplashScreenState extends State<ProSplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _scale = Tween<double>(begin: .94, end: 1.04).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = [
      'sujoy.jpg',
      'ranoes.jpg',
      'monoj.jpg',
      'gpurango.jpg',
      'sourov.jpg',
      'samir.jpg',
      'millon.jpg',
      'ranjon.jpg',
      'subroto.jpg',
      'tonmoy.jpg',
      'dipto.jpg',
      'chandon.jpg',
    ];
    return Scaffold(
      backgroundColor: RbcColors.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scale,
                child: SizedBox(
                  width: 230,
                  height: 230,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 196,
                        height: 196,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: RbcColors.accent.withOpacity(.52), width: 2),
                        ),
                      ),
                      for (var i = 0; i < members.length; i++)
                        Transform.translate(
                          offset: Offset.fromDirection(i * .53, 84),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: RbcColors.accent,
                            backgroundImage: AssetImage('assets/images/members/${members[i]}'),
                          ),
                        ),
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(color: RbcColors.accent, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const Text(
                          'RBC',
                          style: TextStyle(color: RbcColors.primary, fontSize: 26, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 26),
              const Text('রূপসী বাংলা ক্লাব', style: TextStyle(color: RbcColors.surface, fontSize: 25, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('সমাজ • সেবা • শিক্ষা • স্বাস্থ্য • উন্নয়ন', textAlign: TextAlign.center, style: TextStyle(color: RbcColors.surface.withOpacity(.78), fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              const SizedBox(
                width: 170,
                child: LinearProgressIndicator(color: RbcColors.accent, backgroundColor: RbcColors.surface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
