import 'package:crypto_wallet/screens/coin_info_page.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  Widget build(BuildContext context) {
    // return const Text("data");
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              CoinInfoPage(coinName: data['name'], coinId: data['id']))),
      child: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          // color: primary.withOpacity(.4),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.9],
            colors: [
              primary.withOpacity(.4),
              primary.withOpacity(.7),
            ],
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text(
                  data['name'],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 5,
                ),
                Image.network(
                  data['large'],
                  width: 40,
                  height: 40,
                ),
                // Text(
                //   data["price_btc"].toString(),
                //   maxLines: 1,
                //   overflow: TextOverflow.fade,
                //   style:
                //       const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                // ),
                // const SizedBox(
                //   height: 30,
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Price in BTC",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      data["price_btc"].toStringAsFixed(7),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.2),
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      const Text("Market Cap Rank : "),
                      Text(
                        data["market_cap_rank"].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
