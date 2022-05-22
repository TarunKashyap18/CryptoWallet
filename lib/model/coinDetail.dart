class Coin {
  final String coinName;
  final String coinID;
  final String hashing_algo;
  final String description;
  final List<dynamic> homepage;
  final List<dynamic> blockchainSite;
  final String imageUrl;
  final String genesis_date;
  final String marketCapRank;
  final String liquidityScore;
  final String currentPrice;
  final String highIn24H;
  final String lowIn24H;
  final String price_change_percentage_24h_in_currency;
  final String price_change_percentage_7d_in_currency;
  final String price_change_percentage_14d_in_currency;
  final String price_change_percentage_30d_in_currency;
  final String price_change_percentage_60d_in_currency;
  final String price_change_percentage_200d_in_currency;
  final String price_change_percentage_1y_in_currency;
  final List<double> sparkline;

  Coin({
    required this.coinID,
    this.coinName = "Data not available",
    this.hashing_algo = "Data not available",
    this.description = "Data not available",
    this.homepage = const ["Data not available"],
    this.blockchainSite = const ["Data not available"],
    this.imageUrl = "Data not available",
    this.genesis_date = "Data not available",
    this.marketCapRank = "Data not available",
    this.liquidityScore = "Data not available",
    this.currentPrice = "Data not available",
    this.highIn24H = "Data not available",
    this.lowIn24H = "Data not available",
    this.price_change_percentage_24h_in_currency = "Data not available",
    this.price_change_percentage_7d_in_currency = "Data not available",
    this.price_change_percentage_14d_in_currency = "Data not available",
    this.price_change_percentage_30d_in_currency = "Data not available",
    this.price_change_percentage_60d_in_currency = "Data not available",
    this.price_change_percentage_200d_in_currency = "Data not available",
    this.price_change_percentage_1y_in_currency = "Data not available",
    this.sparkline = const [],
  });
  Coin.fromJson(Map json)
      : coinName = json['name'],
        coinID = json['id'],
        description = json['description']['en'],
        homepage = json['links']['homepage'],
        blockchainSite = json['links']['blockchain_site'],
        imageUrl = json['image']['large'],
        hashing_algo = json['hashing_algorithm'].toString(),
        genesis_date = json['genesis_date'].toString(),
        marketCapRank = json['market_cap_rank'].toString(),
        liquidityScore = json['liquidity_score'].toString(),
        currentPrice = json['market_data']['current_price']['inr'].toString(),
        highIn24H = json['market_data']['high_24h']['inr'].toString(),
        lowIn24H = json['market_data']['low_24h']['inr'].toString(),
        price_change_percentage_24h_in_currency =
            json['market_data']['price_change_percentage_24h'].toString(),
        price_change_percentage_7d_in_currency =
            json['market_data']['price_change_percentage_7d'].toString(),
        price_change_percentage_14d_in_currency =
            json['market_data']['price_change_percentage_14d'].toString(),
        price_change_percentage_30d_in_currency =
            json['market_data']['price_change_percentage_30d'].toString(),
        price_change_percentage_60d_in_currency =
            json['market_data']['price_change_percentage_60d'].toString(),
        price_change_percentage_200d_in_currency =
            json['market_data']['price_change_percentage_200d'].toString(),
        price_change_percentage_1y_in_currency =
            json['market_data']['price_change_percentage_1y'].toString(),
        sparkline = json['market_data']['sparkline_7d']['price'].cast<double>();

  Map toJson() {
    return {
      'coinName': coinName,
      'hashing_algo': hashing_algo,
      'description': description,
      'homepage': homepage,
      'blockchainSite': blockchainSite,
      'imageUrl': imageUrl,
      'genesis_date': genesis_date,
      'marketCapRank': marketCapRank,
      'liquidityScore': liquidityScore,
      'currentPrice': currentPrice,
      'highIn24H': highIn24H,
      'lowIn24H': lowIn24H,
      'price_change_percentage_24h_in_currency':
          price_change_percentage_24h_in_currency,
      'price_change_percentage_7d_in_currency':
          price_change_percentage_7d_in_currency,
      'price_change_percentage_14d_in_currency':
          price_change_percentage_14d_in_currency,
      'price_change_percentage_30d_in_currency':
          price_change_percentage_30d_in_currency,
      'price_change_percentage_60d_in_currency':
          price_change_percentage_60d_in_currency,
      'price_change_percentage_200d_in_currency':
          price_change_percentage_200d_in_currency,
      'price_change_percentage_1y_in_currency':
          price_change_percentage_1y_in_currency,
      'sparkline': sparkline,
    };
  }
}
