import 'dart:core';

class CryptoTransactionHistory {
  // ignore: non_constant_identifier_names
  final String image_url;
  final String name;
  final String id;
  final String status;
  final double units;
  final dynamic purchase_price;
  final String date;
  // ignore: non_constant_identifier_names
  CryptoTransactionHistory(
      {required this.purchase_price,
      required this.id,
      required this.date,
      required this.units,
      required this.name,
      required this.status,
      // ignore: non_constant_identifier_names
      required this.image_url});
}

class UserPortfolioData {
  static UserPortfolioData? _instance;
  final String coinName;
  final String imageUrl;
  final dynamic exchangePrice;
  final dynamic purchasePrice;
  final dynamic units;
  final dynamic profitPercentage;

  // static UserPortfolioData get getInstance {
  //   _instance ??= UserPortfolioData.;
  //   return _instance!;
  // }

  UserPortfolioData(
      {required this.coinName,
      required this.imageUrl,
      required this.purchasePrice,
      required this.exchangePrice,
      required this.units,
      required this.profitPercentage});
}
