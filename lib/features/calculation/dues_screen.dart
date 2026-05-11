import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/calculation/calculation_api.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_card.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_table.dart';

class DuesScreen extends StatelessWidget {
const DuesScreen({super.key});

num _numValue(dynamic value) {
if (value is num) return value;
return num.tryParse('$value') ?? 0;
}

String _text(dynamic value) {
if (value == null) return '';
return '$value';
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
  return Scaffold(
  backgroundColor: const Color(0xffF5F7FA),
  appBar: AppBar(
  leading: IconButton(
  icon: const Icon(Icons.arrow_back_ios_new_rounded),
  onPressed: () => Navigator.of(context).maybePop(),
  ),
  title: const Text('বকেয়া হিসাব'),
  ),
  body: const EmptyView(
  title: 'অনুমতি নেই',
  message: 'এই তথ্য দেখার জন্য আপনার পর্যাপ্ত অনুমতি নেই।',
  ),
  );
  }
  return Scaffold(
  backgroundColor: const Color(0xffF5F7FA),
  appBar: AppBar(
  leading: IconButton(
  icon: const Icon(Icons.arrow_back_ios_new_rounded),
  onPressed: () => Navigator.of(context).maybePop(),
  ),
  title: const Text('বকেয়া হিসাব'),
  ),
  body: FutureBuilder<List<List<dynamic>>>(
    future: Future.wait([
    CalculationApi(ApiClient.instance).dues(),
    CalculationApi(ApiClient.instance).adminMonthCada(),
    ]),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const LoadingView(
    message: 'বকেয়ার হিসাব লোড হচ্ছে...',
    );
    }

    if (snapshot.hasError) {
    return EmptyView(
    title: 'বকেয়ার তথ্য লোড করা যায়নি',
    message: ApiClient.messageFrom(snapshot.error!),
    );
    }

    final dues = snapshot.data?[0] ?? [];
    final cada = snapshot.data?[1] ?? [];

    if (dues.isEmpty && cada.isEmpty) {
    return const EmptyView(
    title: 'কোনো বকেয়ার তথ্য পাওয়া যায়নি',
    message: 'এই মুহূর্তে দেখানোর মতো কোনো বকেয়ার হিসাব নেই।',
    );
    }

    return ListView(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
    children: [
    const _Title('গ্রাম এবং ক্লাবের বকেয়ার তালিকা'),

    const ProTableHeader(
    columns: ['নাম', 'বিবরণ', 'পরিমাণ'],
    ),

    for (final d in dues)
    if (d is Map)
    ProTableRow(
    values: [
    _text(d['name']),
    _text(d['source']),
    '${_numValue(d['fixedTk']) - _numValue(d['paidTk'])}',
    ],
    ),

    const SizedBox(height: 18),

    const _Title('ক্লাবের মাসিক চাঁদা বকেয়ার তালিকা'),

    const ProTableHeader(
    columns: [
    'নাম',
    'মাসিক চাঁদা',
    'বকেয়ার সংখ্যা',
    'মোট বকেয়া',
    ],
    ),

    for (final item in cada)
    if (item is Map)
    ProTableRow(
    values: [
    _text(item['name']),
    item['prevMonthName'] == item['currMonthName']
    ? _text(item['currMonthName'])
    : '${_text(item['prevMonthName'])} থেকে ${_text(item['currMonthName'])}',
    _text(item['monthCount']),
    '${_numValue(item['monthCount']) * 50}',
    ],
    ),
    ],
    );
    },
    ),
    );
    }
    }

    class _Title extends StatelessWidget {
    const _Title(this.title);

    final String title;

    @override
    Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
    child: ProCard(
    padding: const EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 16,
    ),
    child: Text(
    title,
    textAlign: TextAlign.center,
    style: const TextStyle(
    color: RbcColors.primary,
    fontWeight: FontWeight.w900,
    ),
    ),
    ),
    );
    }
    }