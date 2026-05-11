import 'package:rbc_flutter_professional/core/services/api_client.dart';
import 'package:rbc_flutter_professional/core/utils/data_parser.dart';

class FestivalApi {
  FestivalApi(this._api);
  final ApiClient _api;

  Future<List<dynamic>> events() async {
    final res = await _api.get('/events');
    final payload = DataParser.safeMap(res.data)['payload'];
    final event = DataParser.safeMap(payload)['event'];
    return event is List ? event : [];
  }
}
