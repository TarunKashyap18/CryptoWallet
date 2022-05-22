import 'package:crypto_wallet/model/transcation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/colors.dart';

class ParticularTranscationPage extends StatelessWidget {
  final List<dynamic> data;
  final String coinName;
  const ParticularTranscationPage(
      {Key? key, required this.data, required this.coinName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<CryptoTransactionHistory> transactions = [];
    for (int i = 0; i < data.length; i++) {
      CryptoTransactionHistory ct = CryptoTransactionHistory(
        purchase_price: data[i].data()['purchase_price'],
        date: data[i].data()['date'],
        units: data[i].data()['count'],
        name: data[i].data()['name'],
        image_url: data[i].data()['image_url'],
        status: data[i].data()['status'],
        id: data[i].data()['id'],
      );
      if (data[i].data()['name'] == coinName) {
        transactions.add(ct);
        // print("ptp:" + ct.name);
      }
    }
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        gradient: LinearGradient(
          colors: [appBgColorPrimary, appBgColorSecondary],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(coinName),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              DateTime tempDate =
                  DateFormat("yyyy-MM-dd").parse(transactions[index].date);
              // var time = temp[1];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    transactions[index].image_url,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(transactions[index].units.toStringAsFixed(6) +
                      " Units Coins at ₹" +
                      transactions[index].purchase_price.toString()),
                  subtitle: Text(
                    "Date: " +
                        tempDate.day.toString() +
                        "/" +
                        tempDate.month.toString() +
                        "/" +
                        tempDate.year.toString(),
                  ),
                  trailing: Text(transactions[index].status),
                ),
              );
            }),
      ),
    );
  }
}
