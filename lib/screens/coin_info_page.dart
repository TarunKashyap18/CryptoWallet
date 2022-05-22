import 'package:crypto_wallet/widgets/buy_alertDailoge.dart';
import 'package:crypto_wallet/widgets/info_show_hide.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/coinDetail.dart';
import '../net/api_methods.dart';
import '../theme/colors.dart';

class CoinInfoPage extends StatefulWidget {
  final String coinName;
  final String coinId;
  const CoinInfoPage({Key? key, required this.coinName, required this.coinId})
      : super(key: key);

  @override
  State<CoinInfoPage> createState() => _CoinInfoPageState();
}

class _CoinInfoPageState extends State<CoinInfoPage> {
  var _data;
  @override
  void initState() {
    _data = ApiRepository().getCoinDetails(widget.coinId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(widget.coinName),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _data,
            builder: ((context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                // print(snapshot.data);
                Map<String, dynamic> data =
                    snapshot.data as Map<String, dynamic>;

                Coin coindetails = Coin.fromJson(data);
                return Column(
                  children: [
                    Consumer(builder: (context, watch, child) {
                      return Card(
                        child: MaterialButton(
                            child: const ListTile(
                              leading: Text("Purchase"),
                              trailing: FaIcon(
                                FontAwesomeIcons.cartPlus,
                              ),
                            ),
                            onPressed: () {
                              BuyMenu.createAlertDialoge(
                                  context, coindetails, watch);
                            }),
                      );
                    }),
                    InfoShowOrHide(
                      title: "Coin Name",
                      data: coindetails.coinName,
                      imageUrl: coindetails.imageUrl,
                    ),
                    InfoShowOrHide(
                      title: "Market Cap Rank",
                      data: coindetails.marketCapRank.toString(),
                    ),
                    InfoShowOrHide(
                      title: "Current Price in Rupees",
                      data: coindetails.currentPrice,
                    ),
                    InfoShowOrHide(
                      title: "Liquidity Score",
                      data: coindetails.liquidityScore,
                    ),
                    InfoShowOrHide(
                      title: "Last 7D",
                      sparkLineData: coindetails.sparkline,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "High in 24h",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "₹" + coindetails.highIn24H,
                                style: const TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Low in 24h",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "₹" + coindetails.lowIn24H,
                                style: const TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Percentage change in 24h",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                coindetails
                                    .price_change_percentage_24h_in_currency,
                                style: const TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Percentage change in 7d",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                coindetails
                                    .price_change_percentage_7d_in_currency,
                                style: const TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Percentage change in 14d",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                coindetails
                                    .price_change_percentage_14d_in_currency,
                                style: const TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Percentage change in 30d",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                coindetails
                                    .price_change_percentage_30d_in_currency,
                                style: const TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Percentage change in 60d",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                coindetails
                                    .price_change_percentage_60d_in_currency,
                                style: const TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Percentage change in 200d",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                coindetails
                                    .price_change_percentage_200d_in_currency,
                                style: const TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Percentage change in 1y",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                coindetails
                                    .price_change_percentage_1y_in_currency,
                                style: const TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InfoShowOrHide(
                      title: "Hashing Algorithm",
                      data: coindetails.hashing_algo,
                    ),
                    InfoShowOrHide(
                      title: "Genesis Date",
                      data: coindetails.genesis_date,
                    ),
                    InfoShowOrHide(
                      title: "Description",
                      dataParagraph: coindetails.description,
                    ),
                    InfoShowOrHide(
                      title: "Homepage",
                      list: coindetails.homepage,
                    ),
                    InfoShowOrHide(
                      title: "BlockChain Site",
                      list: coindetails.blockchainSite,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error :" + snapshot.error.toString() + "😥"),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
