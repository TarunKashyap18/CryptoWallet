import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:riverpod/riverpod.dart';

final apiRepositoryProvider = Provider<ApiRepository>((ref) => ApiRepository());

class ApiRepository {
  Future<List<dynamic>> getCoinsMarketData() async {
    final response = await http.get(
      Uri.parse(
          "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=100&sparkline=false"),
    );
    final json = jsonDecode(response.body.toString());
    return json;
  }

  Future<List<dynamic>> getAllCoinsName() async {
    final response = await http.get(
      Uri.parse("https://api.coingecko.com/api/v3/coins/list"),
    );
    final json = jsonDecode(response.body.toString());
    return json;
  }

  getTrandingCoins() async {
    final response = await http.get(
      Uri.parse("https://api.coingecko.com/api/v3/search/trending"),
    );
    final json = jsonDecode(response.body.toString());
    return json;
  }

  getCoinPrice(String coinName) async {
    final response = await http.get(
      Uri.parse("https://api.coingecko.com/api/v3/simple/price?ids=" +
          coinName +
          "&vs_currencies=inr"),
    );
    final json = jsonDecode(response.body.toString());
    return json;
  }

  getCoinDetails(String coinName) async {
    final response = await http.get(
      Uri.parse("https://api.coingecko.com/api/v3/coins/" +
          coinName +
          "?localization=false&tickers=false&community_data=false&developer_data=false&sparkline=true"),
    );
    final json = jsonDecode(response.body.toString());
    return json;
  }
}
