import 'package:dio/dio.dart';
import 'package:rbc_flutter_professional/core/config/app_config.dart';
import 'package:rbc_flutter_professional/core/services/api_client.dart';

class PostApi {
  PostApi(this._api);
  final ApiClient _api;

  Future<List<dynamic>> posts() async {
    final res = await _api.get('/api/v1/app-posts');
    return res.data is List ? res.data : [];
  }

  Future<List<dynamic>> userPosts(String token) async {
    final res = await _api.get('/api/v1/app-posts/user/posts', token: token);
    return res.data is List ? res.data : [];
  }

  Future<void> createPost(Map<String, dynamic> payload, String token) async {
    await _api.post('/api/v1/app-posts', data: payload, token: token);
  }

  Future<void> deletePost(String id, String token) async {
    await _api.delete('/api/v1/app-posts/$id', token: token);
  }

  Future<void> comment(Map<String, dynamic> payload, String token) async {
    await _api.post('/api/v1/app-comment/create-comment', data: payload, token: token);
  }

  Future<void> reaction(Map<String, dynamic> payload, String token) async {
    await _api.post('/api/v1/app-comment/create-reaction', data: payload, token: token);
  }

  Future<String?> uploadToImgBb(String filePath) async {
    if (AppConfig.imgbbApiKey.isEmpty) return null;
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath, filename: 'upload.jpg'),
    });
    final response = await Dio().post(
      'https://api.imgbb.com/1/upload?key=${AppConfig.imgbbApiKey}',
      data: formData,
    );
    return response.data?['data']?['display_url'] as String?;
  }
}
