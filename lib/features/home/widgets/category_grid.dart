import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/calculation/dues_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/income_by_category_screen.dart';
import 'package:rbc_flutter_professional/features/calculation/puja_history_screen.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static final categories = [
    _Category('durga', 'দূর্গা পূজা', 'assets/images/debiIcon/durga.png', 'puja'),
    _Category('kali', 'কালী পূজা', 'assets/images/debiIcon/kali.png', 'puja'),
    _Category('sorosothi', 'সরস্বতী পূজা', 'assets/images/debiIcon/sarasathi.png', 'puja'),
    _Category('chotoro', 'শিব পূজা', 'assets/images/debiIcon/mohadeb.png', 'puja'),
    _Category('basto', 'বাস্ত পূজা', 'assets/images/debiIcon/basto.png', 'puja'),
    _Category('dhak', 'ঢাকের দক্ষিণা', 'assets/images/debiIcon/dhol.png', 'income'),
    _Category('jomi', 'জমির লিজ', 'assets/images/debiIcon/land.png', 'income'),
    _Category('dues', 'বকেয়া অর্থ', 'assets/images/debiIcon/due.png', 'dues'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 14,
        crossAxisSpacing: 8,
        childAspectRatio: .78,
      ),
      itemBuilder: (context, index) {
        final item = categories[index];
        return InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => _open(context, item),
          child: Column(
            children: [
              Container(
                width: 62,
                height: 62,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: index.isEven ? RbcColors.primary : RbcColors.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: RbcColors.primary.withOpacity(.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Image.asset(item.asset),
              ),
              const SizedBox(height: 7),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  color: RbcColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _open(BuildContext context, _Category item) {
    Widget screen;
    if (item.type == 'puja') {
      screen = PujaHistoryScreen(category: item.key, title: item.title);
    } else if (item.type == 'income') {
      screen = IncomeByCategoryScreen(category: item.key, title: item.title);
    } else {
      screen = const DuesScreen();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _Category {
  _Category(this.key, this.title, this.asset, this.type);
  final String key;
  final String title;
  final String asset;
  final String type;
}
