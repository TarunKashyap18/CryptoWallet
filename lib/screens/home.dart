import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../screens/auth_pages/login_page.dart';
import '../screens/particular_transaction_page.dart';

import '../net/api_methods.dart';
import '../widgets/tranding_coin_widget.dart';
import '../widgets/coin_card.dart';
import '../model/transcation.dart';
import '../theme/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _data;
  var _coinPriceData;
  HashMap<String, double> priceOfCoin = HashMap();
  late List<CryptoTransactionHistory> data;
  // late List<String> _coinsList;
  List<double> profitDataForSparkline = [];
  @override
  void initState() {
    _data = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Transaction')
        .snapshots();
  }

  List<UserPortfolioData> userPortfolioData = [];
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
          title: const Text("Home"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                icon: const FaIcon(FontAwesomeIcons.signOutAlt)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _data,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Got some Error :" + snapshot.error.toString() + " 😥",
                        style: const TextStyle(fontSize: 25),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<CryptoTransactionHistory> data =
                        createMapOfCoins(snapshot.data.docs);
                    // return const Text('data');

                    _coinPriceData = setPrice(data);

                    return FutureBuilder(
                      future: _coinPriceData,
                      // future: setPrice(data),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot1) {
                        if (snapshot1.hasData) {
                          //
                          userPortfolioData = setPortfolioData(data, snapshot1);

                          profitDataForSparkline = setProfitData();

                          if (userPortfolioData.isNotEmpty) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Title(
                                      color: Colors.white,
                                      child: const Text(
                                        "Transaction History",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                Flexible(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: userPortfolioData.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: CoinCard(
                                            todayPrice: userPortfolioData[index]
                                                .exchangePrice
                                                .toString(),
                                            image: userPortfolioData[index]
                                                .imageUrl,
                                            name: userPortfolioData[index]
                                                .coinName,
                                            id: userPortfolioData[index].coinId,
                                            units: userPortfolioData[index]
                                                .units
                                                .toStringAsFixed(6),
                                            profit: Text("Profit: " +
                                                userPortfolioData[index]
                                                    .profitPercentage
                                                    .toStringAsFixed(2) +
                                                "%"),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: ((context) =>
                                                  ParticularTranscationPage(
                                                      data: snapshot.data.docs,
                                                      coinName:
                                                          userPortfolioData[
                                                                  index]
                                                              .coinName)),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    // color: primary.withOpacity(.4),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: const [0.1, 0.9],
                                      colors: [
                                        primary.withOpacity(0.1),
                                        primary.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                  child: const ExpansionTile(
                                    initiallyExpanded: true,
                                    title: Text(
                                      "Tranding",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    children: [
                                      ShowTrandingCoin(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Lottie.asset('assets/no_data.json'),
                                const Center(
                                  child: Text(
                                    "Purchase some currency 🙂",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                const ShowTrandingCoin(),
                              ],
                            );
                          }
                        } else if (snapshot1.hasError) {
                          return Center(
                            child: Text(
                              "Got some Error : " +
                                  snapshot1.error.toString() +
                                  "😥",
                              style: const TextStyle(fontSize: 25),
                            ),
                          );
                        } else if (snapshot1.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else {
                          return const Text("Purchase some currency");
                        }
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else {
                    return const Text("Purchase some currency");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  setProfitData() {
    List<double> temp = [];
    for (var item in userPortfolioData) {
      temp.add(item.profitPercentage);
    }
    return temp;
  }

  setPortfolioData(
      List<CryptoTransactionHistory> data, AsyncSnapshot<dynamic> snapshot1) {
    List<UserPortfolioData> temp = [];
    for (int i = 0; i < data.length; i++) {
      var profit = ((snapshot1.data[data[i].name] - data[i].purchase_price) /
              data[i].purchase_price) *
          100;
      temp.add(UserPortfolioData(
        coinName: data[i].name,
        coinId: data[i].id,
        imageUrl: data[i].image_url,
        exchangePrice: snapshot1.data[data[i].name],
        purchasePrice: data[i].purchase_price,
        units: data[i].units,
        profitPercentage: profit,
      ));
    }
    return temp;
  }

  setPrice(List<CryptoTransactionHistory> data) async {
    HashMap<String, double> map = HashMap();
    for (var item in data) {
      var temp = await ApiRepository().getCoinPrice(item.id);
      map.putIfAbsent(item.name, () => temp[item.id]['inr'].toDouble());
    }
    return map;
  }

  createMapOfCoins(dynamic input) {
    // print("from home " + input.toString());
    HashMap<String, CryptoTransactionHistory> map = HashMap();
    for (var item in input) {
      if (!map.containsKey(item.data()['name'])) {
        CryptoTransactionHistory temp = CryptoTransactionHistory(
          purchase_price: item.data()['purchase_price'],
          date: item.data()['date'],
          units: item.data()['count'],
          name: item.data()['name'],
          status: item.data()['status'],
          image_url: item.data()['image_url'],
          id: item.data()['id'],
        );
        map[item.data()['name']] = temp;
      } else {
        if (item.data()['status'] == "Purchased") {
          CryptoTransactionHistory temp = CryptoTransactionHistory(
            date: item.data()['date'],
            units: item.data()['count'] + map[item.data()['name']]!.units,
            name: item.data()['name'],
            image_url: item.data()['image_url'],
            purchase_price: item.data()['purchase_price'] +
                (map[item.data()['name']]!.purchase_price -
                    item.data()['purchase_price']),
            status: item.data()['status'],
            id: item.data()['id'],
          );
          map[item.data()['name']] = temp;
        } else {
          CryptoTransactionHistory temp = CryptoTransactionHistory(
            date: item.data()['date'],
            units: item.data()['count'] - map[item.data()['name']]!.units,
            name: item.data()['name'],
            image_url: item.data()['image_url'],
            purchase_price: item.data()['purchase_price'] -
                (map[item.data()['name']]!.purchase_price -
                    item.data()['purchase_price']),
            status: item.data()['status'],
            id: item.data()['id'],
          );
          map[item.data()['name']] = temp;
        }
      }
    }
    List<CryptoTransactionHistory> coinsOwned = [];
    map.forEach((k, v) {
      coinsOwned.add(v);
    });
    return coinsOwned;
  }

  Widget calculateProfit({required dynamic cp, required dynamic sp}) {
    final String result;
    if (cp < sp) {
      double n = sp - cp + 0.0;
      double d = cp + 0.0;
      result = ((n / d) * 100).toStringAsFixed(2);
      return Text(
        "Profit: ↑ " + result + "%",
        style: const TextStyle(
            color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500),
      );
    } else {
      double n = cp - sp + 0.0;
      double d = cp + 0.0;
      result = ((n / d) * 100).toStringAsFixed(2);
      return Text(
        "Profit: ↓ " + result + "%",
        style: const TextStyle(
            color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
      );
    }
  }

  createAlertDialoge(
      {required BuildContext context,
      required Map<String, dynamic> data1,
      required dynamic data2}) {
    AlertDialog alert = AlertDialog(
      title: Text(
        data2.data()['name'],
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: [
            Text("Coins : ${data2.data()['count']}"),
            Text(
                "Puchased Price : ${data2.data()['purchase_price'] * data2.data()['count']}"),
            Text(
                "Exchange Price : ${(data1[data2.data()['name']] * data2.data()['count']).toStringAsFixed(2)}"),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Exchange"),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // createNewMap(dynamic input) {
  //   List<CryptoTransaction> coinsOwned = [];
  //   HashMap<String, CryptoTransaction> map = HashMap();
  //   for (int i = 0; i < input.length; i++) {
  //     if (!map.containsKey(input[i].data()['name'])) {
  //       CryptoTransaction temp = CryptoTransaction(
  //         date: input[i].data()['date'],
  //         count: input[i].data()['count'],
  //         name: input[i].data()['name'],
  //         image_url: input[i].data()['image_url'],
  //         purchase_price: input[i].data()['purchase_price'],
  //       );
  //       map[input[i].data()['name']] = temp;
  //     } else {
  //       CryptoTransaction temp = CryptoTransaction(
  //         date: input[i].data()['date'],
  //         count: input[i].data()['count'] + map[input[i].data()['name']]!.count,
  //         name: input[i].data()['name'],
  //         image_url: input[i].data()['image_url'],
  //         purchase_price: input[i].data()['purchase_price'] +
  //             (map[input[i].data()['name']]!.purchase_price -
  //                 input[i].data()['purchase_price']),
  //       );
  //       map[input[i].data()['name']] = temp;
  //     }
  //   }
  //   map.forEach((k, v) {
  //     coinsOwned.add(v);
  //   });
  //   return coinsOwned;
  // }
}
