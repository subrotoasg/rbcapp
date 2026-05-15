import '../core/services/api_client.dart';

class VillageApi {
  VillageApi(this._api);
  final ApiClient _api;

  Future<List<dynamic>> getAllPeople() async {
    final res = await _api.get('/api/v1/village-people');
    return res.data['data'] is List ? res.data['data'] : [];
  }

  Future<Map<String, dynamic>> getFamilyTree(String id) async {
    final res = await _api.get('/api/v1/village-people/family/tree/$id');
    return res.data['data'] ?? {};
  }

  Future<void> createPerson(Map<String, dynamic> payload, String token) async {
    await _api.post('/api/v1/village-people', data: payload, token: token);
  }

  Future<void> updatePerson(String id, Map<String, dynamic> payload, String token) async {
    // API Route অনুযায়ী PUT ব্যবহার করা হয়েছে
    await _api.put('/api/v1/village-people/$id', data: payload, token: token);
  }

  Future<void> deletePerson(String id, String token) async {
    await _api.delete('/api/v1/village-people/$id', token: token);
  }
}