import 'package:rbc_flutter_professional/core/utils/bangla_number.dart';

class PujaMath {
  PujaMath._();

  static Map<String, num> calculate(Map<String, dynamic> item) {
    final income = item['income'] is List ? item['income'] as List : [];
    final spend = item['spend'] is List ? item['spend'] as List : [];
    num get(List arr, int i, String key) {
      if (arr.length <= i || arr[i] is! Map) return 0;
      return BanglaNumber.toNumber((arr[i] as Map)[key]);
    }

    final totalIncome = get(income, 0, 'vPronami') + get(income, 1, 'totalGift') + get(income, 2, 'govtGift');
    final totalSpend = get(spend, 0, 'protima') +
        get(spend, 1, 'birammon') +
        get(spend, 2, 'spendPuja') +
        get(spend, 3, 'prosadh') +
        get(spend, 4, 'decoration') +
        get(spend, 5, 'boxLight') +
        get(spend, 6, 'ancher') +
        get(spend, 7, 'otherSpand');
    return {
      'totalIncome': totalIncome,
      'totalSpend': totalSpend,
      'dueOrExtra': totalIncome - totalSpend,
    };
  }

  static List<Map<String, dynamic>> extractPronami(dynamic html) {
    final text = '$html'.replaceAll('\n', '').trim();
    final regex = RegExp(r'<li><strong>(.*?) = (\d+)\s*</strong></li>');
    return regex.allMatches(text).map((m) {
      return {'name': m.group(1)?.trim() ?? '', 'amount': num.tryParse(m.group(2) ?? '0') ?? 0};
    }).toList();
  }
}
