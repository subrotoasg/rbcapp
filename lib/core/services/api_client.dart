import 'package:dio/dio.dart';
import 'package:rbc_flutter_professional/core/config/app_config.dart';

class ApiClient {
  ApiClient._() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.backendUrl,
      connectTimeout: const Duration(seconds: 25),
      receiveTimeout: const Duration(seconds: 25),
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<Response<dynamic>> get(String path, {String? token}) {
    return dio.get(path, options: _options(token));
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    String? token,
    Options? options,
  }) {
    return dio.post(path, data: data, options: options ?? _options(token));
  }

  Future<Response<dynamic>> delete(String path, {String? token}) {
    return dio.delete(path, options: _options(token));
  }

  Options _options(String? token) {
    return Options(
      headers: token == null || token.isEmpty
          ? null
          : {'authorization': 'Bearer $token'},
    );
  }

  static String messageFrom(Object error) {
    final raw = error.toString();
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'সার্ভার থেকে সাড়া পেতে সময় লাগছে। আবার চেষ্টা করুন।';
      }
      if (error.response?.statusCode == 401) {
        return 'সেশন যাচাই করা যায়নি। আবার লগইন করুন।';
      }
      if (error.response?.statusCode == 404) {
        return 'তথ্য পাওয়া যায়নি।';
      }
      if (error.response?.statusCode != null && error.response!.statusCode! >= 500) {
        return 'সার্ভারে সমস্যা হচ্ছে। কিছুক্ষণ পর চেষ্টা করুন।';
      }
    }
    if (raw.contains('SocketException') || raw.contains('connection')) {
      return 'ইন্টারনেট সংযোগ পাওয়া যাচ্ছে না।';
    }
    return 'অনুরোধটি সম্পন্ন করা যায়নি। আবার চেষ্টা করুন।';
  }
}
