class BanglaNumber {
  BanglaNumber._();

  static const _map = {
    '০': '0',
    '১': '1',
    '২': '2',
    '৩': '3',
    '৪': '4',
    '৫': '5',
    '৬': '6',
    '৭': '7',
    '৮': '8',
    '৯': '9',
  };

  static String toEnglish(dynamic input) {
    final value = '${input ?? ''}';
    return value.split('').map((c) => _map[c] ?? c).join();
  }

  static num toNumber(dynamic input) {
    return num.tryParse(toEnglish(input)) ?? 0;
  }
}
