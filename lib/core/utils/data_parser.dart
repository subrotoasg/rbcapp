class DataParser {
  DataParser._();

  static List<dynamic> asList(dynamic value, {String? key}) {
    final target = key == null ? value : safeMap(value)[key];
    if (target is List) return target;
    return const [];
  }

  static Map<String, dynamic> safeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.map((k, v) => MapEntry('$k', v));
    return <String, dynamic>{};
  }

  static String text(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    return '$value';
  }
}
