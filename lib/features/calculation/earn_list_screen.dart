import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/auth/auth_controller.dart';
import 'package:rbc_flutter_professional/features/calculation/calculation_api.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_table.dart';

class EarnListScreen extends StatefulWidget {
  const EarnListScreen({super.key});

  @override
  State<EarnListScreen> createState() => _EarnListScreenState();
}

class _EarnListScreenState extends State<EarnListScreen> {
  Future<List<dynamic>>? earnsFuture;
  String? lastSearch;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = context.watch<AuthController>().user;
    if (user == null) return;
    final search = user.isPrivileged == true ? '' : 'village';

    if (earnsFuture == null || lastSearch != search) {
      lastSearch = search;
      earnsFuture = CalculationApi(ApiClient.instance).earns(search);
    }
  }

  Future<void> _refresh() async {
    final user = context.read<AuthController>().user;
    if (user == null) return;

    final search = user.isPrivileged == true ? '' : 'village';

    setState(() {
      lastSearch = search;
      earnsFuture = CalculationApi(ApiClient.instance).earns(search);
    });

    await earnsFuture;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;

    if (user == null || earnsFuture == null) {
      return const Scaffold(
        body: LoadingView(message: 'ব্যবহারকারীর তথ্য লোড হচ্ছে...'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('আয়ের হিসাব'),
      ),
      body: RefreshIndicator(
        color: RbcColors.primary,
        onRefresh: _refresh,
        child: FutureBuilder<List<dynamic>>(
          future: earnsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView(message: 'আয়ের তালিকা লোড হচ্ছে...');
            }

            if (snapshot.hasError) {
              return EmptyView(
                title: 'আয়ের তথ্য লোড করা যায়নি',
                message: ApiClient.messageFrom(snapshot.error!),
                buttonText: 'আবার চেষ্টা করুন',
                onPressed: _refresh,
              );
            }

            final data = snapshot.data ?? [];

            if (data.isEmpty) {
              return EmptyView(
                title: 'কোনো আয়ের তথ্য পাওয়া যায়নি',
                message: 'এই মুহূর্তে দেখানোর মতো কোনো আয় হিসাব নেই। নতুন আয় যুক্ত হলে এখানে দেখা যাবে।',
                buttonText: 'রিফ্রেশ করুন',
                onPressed: _refresh,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: data.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return const ProTableHeader(
                    columns: [
                      'তারিখ',
                      'প্রদানকারী',
                      'বিবরণ',
                      'পরিমাণ',
                    ],
                  );
                }

                final item = data[i - 1];

                if (item is! Map) {
                  return const SizedBox.shrink();
                }

                return ProTableRow(
                  values: [
                    '${item['earnDate'] ?? ''}',
                    '${item['senderName'] ?? ''}',
                    '${item['earnDetails'] ?? ''}',
                    '${item['earnValue'] ?? ''}',
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}