import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/calculation/calculation_api.dart';
import 'package:rbc_flutter_professional/features/calculation/puja_pronami_screen.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';

class MonthCadaScreen extends StatefulWidget {
  const MonthCadaScreen({super.key});

  @override
  State<MonthCadaScreen> createState() => _MonthCadaScreenState();
}

class _MonthCadaScreenState extends State<MonthCadaScreen> {
  static const months = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর',
  ];

  Future<List<dynamic>>? cadaFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = context.watch<AuthController>().user;

    if (user?.isPrivileged == true && cadaFuture == null) {
      cadaFuture = CalculationApi(ApiClient.instance).userMonthCada(user?.token ?? '');
    }
  }

  Future<void> _refresh() async {
    final user = context.read<AuthController>().user;

    if (user?.isPrivileged != true) return;

    setState(() {
      cadaFuture = CalculationApi(ApiClient.instance).userMonthCada(user?.token ?? '');
    });

    await cadaFuture;
  }

  num _toNum(dynamic value) {
    if (value is num) return value;

    return num.tryParse(
          '$value'
              .replaceAll(',', '')
              .replaceAll('৳', '')
              .replaceAll('TK', '')
              .replaceAll('Tk', '')
              .trim(),
        ) ??
        0;
  }

  List<_YearCada> _buildYears(List<dynamic> data) {
    final baseYear = 2014 + data.length;
    final years = <_YearCada>[];

    for (int i = 0; i < data.length; i++) {
      final raw = data[i];
      final arr = raw is List ? raw : [];

      final monthsData = <_MonthCada>[];

      for (int j = 0; j < arr.length && j < 12; j++) {
        final value = arr[j];

        if (value == null || _toNum(value) == 0) continue;

        monthsData.add(
          _MonthCada(
            monthName: months[j],
            amount: _toNum(value),
          ),
        );
      }

      if (monthsData.isEmpty) continue;

      years.add(
        _YearCada(
          year: baseYear - i,
          months: monthsData,
        ),
      );
    }

    return years;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xffF5F7FA),
        body: LoadingView(
          message: 'ব্যবহারকারীর তথ্য লোড হচ্ছে...',
        ),
      );
    }

    if (user.isPrivileged != true) {
      return const PujaPronamiScreen();
    }

        return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('মাসিক চাঁদা'),
      ),
      body: RefreshIndicator(
        color: RbcColors.primary,
        onRefresh: _refresh,
        child: FutureBuilder<List<dynamic>>(
          future: cadaFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView(
                message: 'মাসিক চাঁদার তথ্য লোড হচ্ছে...',
              );
            }

            if (snapshot.hasError) {
              return EmptyView(
                message: ApiClient.messageFrom(snapshot.error!),
              );
            }

            final data = snapshot.data ?? [];
            final years = _buildYears(data);

            if (years.isEmpty) {
              return const EmptyView(
                message: 'চাঁদার কোনো তথ্য পাওয়া যায়নি। নতুন চাঁদা যুক্ত হলে এখানে দেখা যাবে।',
              );
            }

            final totalAmount = years.fold<num>(
              0,
              (sum, year) => sum + year.totalAmount,
            );

            final totalMonths = years.fold<int>(
              0,
              (sum, year) => sum + year.months.length,
            );

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                _SummaryCard(
                  totalYears: years.length,
                  totalMonths: totalMonths,
                  totalAmount: totalAmount,
                ),

                const SizedBox(height: 10),

                ...years.map(
                  (item) => _YearCadaCard(yearCada: item),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.totalYears,
    required this.totalMonths,
    required this.totalAmount,
  });

  final int totalYears;
  final int totalMonths;
  final num totalAmount;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      highlight: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'মাসিক চাঁদার সারাংশ',
            style: TextStyle(
              color: RbcColors.accent,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'আপনার মাসিক চাঁদা প্রদানের বছরভিত্তিক হিসাব',
            style: TextStyle(
              color: RbcColors.surface.withOpacity(.82),
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  title: 'বছর',
                  value: '$totalYears',
                  icon: Icons.calendar_month_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryTile(
                  title: 'মাস',
                  value: '$totalMonths',
                  icon: Icons.event_available_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryTile(
                  title: 'মোট',
                  value: '৳$totalAmount',
                  icon: Icons.payments_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.14),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: RbcColors.accent,
            size: 22,
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: RbcColors.surface,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              color: RbcColors.surface.withOpacity(.72),
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _YearCadaCard extends StatelessWidget {
  const _YearCadaCard({
    required this.yearCada,
  });

  final _YearCada yearCada;

  @override
  Widget build(BuildContext context) {
    final paidCount = yearCada.months.length;
    final progress = paidCount / 12;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ProCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: RbcColors.accent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: RbcColors.primary,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${yearCada.year} সালের চাঁদা',
                        style: const TextStyle(
                          color: RbcColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$paidCount মাস জমা • মোট ৳${yearCada.totalAmount}',
                        style: TextStyle(
                          color: RbcColors.primary.withOpacity(.62),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: RbcColors.primary.withOpacity(.08),
                color: RbcColors.accent,
              ),
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: yearCada.months
                  .map(
                    (month) => _MonthChip(month: month),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  const _MonthChip({
    required this.month,
  });

  final _MonthCada month;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: RbcColors.primary.withOpacity(.06),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: RbcColors.primary.withOpacity(.07),
        ),
      ),
      child: Text(
        '${month.monthName}: ৳${month.amount}',
        style: const TextStyle(
          color: RbcColors.primary,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _YearCada {
  const _YearCada({
    required this.year,
    required this.months,
  });

  final int year;
  final List<_MonthCada> months;

  num get totalAmount {
    return months.fold<num>(
      0,
      (sum, month) => sum + month.amount,
    );
  }
}

class _MonthCada {
  const _MonthCada({
    required this.monthName,
    required this.amount,
  });

  final String monthName;
  final num amount;
}