import 'package:crypto_wallet/net/flutterFire.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:string_validator/string_validator.dart';
import '../net/providers.dart';
import '../theme/colors.dart';
import 'avatar_image.dart';

List<Color> stateColors = [stayColor, upColor, downColor];

class CoinItem extends StatelessWidget {
  const CoinItem({
    required this.coinData,
    required this.watcher,
    Key? key,
    this.onTap,
  }) : super(key: key);
  final coinData;
  final watcher;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: glassColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvatarImage(
                  coinData['image'],
                  isSVG: false,
                  width: 30,
                  height: 30,
                  radius: 50,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(coinData['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700))),
                          const SizedBox(width: 5),
                          Text(
                              "Today Price : ₹" +
                                  coinData['current_price'].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600))
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                "Market Cap Rank : " +
                                    coinData['market_cap_rank'].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                )),
                          ),
                          Text(
                              "Change in 24H : " +
                                  coinData['price_change_percentage_24h']
                                      .toStringAsFixed(2) +
                                  "%",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 11, color: stateColors[0]))
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.cartPlus,
                  ),
                  onPressed: () {
                    createAlertDialoge(context, coinData, watcher);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createAlertDialoge(
      BuildContext context, Map<String, dynamic> data, ScopedReader watch) {
    TextEditingController _amountController = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: Center(child: Text(data['name'])),
      content: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text("Amount"),
              ),
            ),
            MaterialButton(
                onPressed: () {
                  if (toDouble(_amountController.text.trim()) <=
                      watch(walletBalanceProvider).state) {
                    watch(authRepositoryProvider).purchaseCoin(
                      amount: _amountController.text.trim(),
                      price: data['current_price'].toString(),
                      imageUrl: data['image'],
                      name: data['name'],
                      id: data['id'],
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(data['name'] + " Successfully Purchased")));
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(" Not enough balance in the Wallet ")));
                  }
                },
                child: const Text("Buy"))
          ],
        ),
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
