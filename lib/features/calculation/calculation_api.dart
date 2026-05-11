import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/utils/data_parser.dart';
import 'package:flutter/material.dart';

class CalculationApi {
  CalculationApi(this._api);
  final ApiClient _api;

  Future<List<dynamic>> earns([String search = '']) async {
    final res = await _api.get('/api/v1/earns?search=$search');
    return res.data is List ? res.data : [];
  }

  Future<List<dynamic>> spends([String search = '']) async {
    final res = await _api.get('/api/v1/spends?search=$search');
    return res.data is List ? res.data : [];
  }

  Future<List<dynamic>> userMonthCada(String token) async {
    final res = await _api.get('/api/month/cada/', token: token);
    return DataParser.asList(res.data, key: 'payment');
  }

  Future<List<dynamic>> adminMonthCada() async {
    final res = await _api.get('/api/month/cada/admin');
    return res.data is List ? res.data : [];
  }

  Future<List<dynamic>> dues() async {
    final res = await _api.get('/due/details');
    return DataParser.asList(res.data, key: 'payload');
  }

  Future<List<dynamic>> pujaPronami() async {
    final res = await _api.get('/cada/details');
    return DataParser.asList(res.data, key: 'payload');
  }

  Future<String> pujaPronamiTitle() async {
    final res = await _api.get('/title/heading');
    final list = DataParser.asList(res.data, key: 'payload');
    if (list.isEmpty || list.first is! Map) return 'পূজার প্রণামী';
    return '${(list.first as Map)['title'] ?? 'পূজার প্রণামী'}';
  }

  Future<List<dynamic>> pujaParbon() async {
    final res = await _api.get('/puja/parbon');
    return res.data is List ? res.data : [];
  }
}
