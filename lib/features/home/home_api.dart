import 'package:rbc_flutter_professional/core/services/api_client.dart';

class HomeApi {
  HomeApi(this._api);
  final ApiClient _api;

  Future<List<dynamic>> banners() async => (await _api.get('/api/v1/banners')).data as List<dynamic>? ?? [];
  Future<List<dynamic>> topBanners() async => (await _api.get('/api/v1/top-banners')).data as List<dynamic>? ?? [];
  Future<List<dynamic>> bottomBanners() async => (await _api.get('/api/v1/bottom-banners')).data as List<dynamic>? ?? [];
}
