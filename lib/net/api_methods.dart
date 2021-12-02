import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:riverpod/riverpod.dart';

final apiRepositoryProvider = Provider<ApiRepository>((ref) => ApiRepository());

class ApiRepository {
  Future<List<dynamic>> getCoinsMarketData() async {
    final response = await http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=100&sparkline=false"));
    final json = jsonDecode(response.body.toString());
    return json;
  }
}
