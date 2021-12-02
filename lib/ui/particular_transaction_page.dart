import 'package:crypto_wallet/model/transcation.dart';
import 'package:flutter/material.dart';

class ParticularTranscationPage extends StatelessWidget {
  final List<dynamic> data;
  final String coinName;
  const ParticularTranscationPage(
      {Key? key, required this.data, required this.coinName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<CryptoTransaction> transactions = [];
    for (int i = 0; i < data.length; i++) {
      CryptoTransaction ct = CryptoTransaction(
        purchase_price: data[i].data()['purchase_price'],
        date: data[i].data()['date'],
        count: data[i].data()['count'],
        name: data[i].data()['name'],
        image_url: data[i].data()['image_url'],
      );
      if (data[i].data()['name'] == coinName) {
        transactions.add(ct);
        // print("ptp:" + ct.name);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(coinName),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network(transactions[index].image_url),
              title: Text(transactions[index].count.toString() +
                  " Coins at ₹" +
                  transactions[index].purchase_price.toString()),
              subtitle: Text(transactions[index].date),
            );
          }),
    );
  }
}
