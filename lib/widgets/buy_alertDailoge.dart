import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:string_validator/string_validator.dart';

import '../model/coinDetail.dart';
import '../net/flutterFire.dart';
import '../net/providers.dart';

class BuyMenu {
  static createAlertDialoge(
      BuildContext context, Coin data, ScopedReader watch) {
    TextEditingController _amountController = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: Center(child: Text(data.coinName)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("Units"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
              onPressed: () {
                if (toDouble(_amountController.text.trim()) <=
                    watch(walletBalanceProvider).state) {
                  watch(authRepositoryProvider).purchaseCoin(
                    amount: _amountController.text.trim(),
                    price: data.currentPrice.toString(),
                    imageUrl: data.imageUrl,
                    name: data.coinName,
                    id: data.coinID,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text(data.coinName + " Successfully Purchased")));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(" Not enough balance in the Wallet ")));
                }
              },
              child: const Text("Buy"))
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
