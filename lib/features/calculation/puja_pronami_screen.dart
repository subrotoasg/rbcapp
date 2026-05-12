import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/features/calculation/calculation_api.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';
import 'package:rbc_flutter_professional/shared/widgets/pro_table.dart';

class PujaPronamiScreen extends StatelessWidget {
  const PujaPronamiScreen({
    super.key,
    this.embed = false,
  });

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final body = FutureBuilder<List<dynamic>>(
      future: CalculationApi(ApiClient.instance).pujaPronami(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView(
            message: 'পূজার প্রণামীর তথ্য লোড হচ্ছে...',
          );
        }

        if (snapshot.hasError) {
          return EmptyView(
            title: 'তথ্য লোড করা যায়নি',
            message: ApiClient.messageFrom(snapshot.error!),
          );
        }

        final data = snapshot.data ?? [];

        if (data.isEmpty) {
          return const EmptyView(
            title: 'কোনো তথ্য পাওয়া যায়নি',
            message: 'পূজার প্রণামীর কোনো তথ্য এখনো যুক্ত করা হয়নি।',
          );
        }

        return FutureBuilder<String>(
          future: CalculationApi(ApiClient.instance).pujaPronamiTitle(),
          builder: (context, titleSnap) {
            final title = titleSnap.data ?? 'পূজার প্রণামী';

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                embed ? 96 : 28,
              ),
              itemCount: data.length + 2,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: RbcColors.accent,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: RbcColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        height: 1.35,
                      ),
                    ),
                  );
                }

                if (i == 1) {
                  return const ProTableHeader(
                    columns: [
                      'নাম',
                      'ধার্যকৃত অর্থ',
                      'প্রদানকৃত অর্থ',
                    ],
                  );
                }

                final item = data[i - 2];

                if (item is! Map) {
                  return const SizedBox.shrink();
                }

                return ProTableRow(
                  values: [
                    '${item['name'] ?? ''}',
                    '${item['fixedTk'] ?? ''}',
                    '${item['paidTk'] ?? ''}',
                  ],
                );
              },
            );
          },
        );
      },
    );

    if (embed) return body;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('পূজার প্রণামী'),
      ),
      body: body,
    );
  }
}