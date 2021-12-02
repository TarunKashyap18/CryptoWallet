import 'dart:core';

class CryptoTransaction {
  // ignore: non_constant_identifier_names
  final String image_url;
  final String name;
  final double count;
  final dynamic purchase_price;
  final String date;
  // ignore: non_constant_identifier_names
  CryptoTransaction(
      {required this.purchase_price,
      required this.date,
      required this.count,
      required this.name,
      // ignore: non_constant_identifier_names
      required this.image_url});
}
