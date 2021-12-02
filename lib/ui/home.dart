import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/model/transcation.dart';
import 'package:crypto_wallet/net/api_methods.dart';
import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:crypto_wallet/ui/login_page.dart';
import 'package:crypto_wallet/ui/particular_transaction_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  setValues(List<dynamic> input) {
    Map<String, double> coinsPrice = {};
    for (var element in input) {
      coinsPrice.putIfAbsent(
          element['name'], () => element['current_price'] + 0.0);
    }
    return coinsPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                signout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.signOutAlt)),
        ],
      ),
      body: Column(
        children: [
          Consumer(
            builder: (BuildContext context, watch, child) {
              return Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('Transaction')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<dynamic> snapshot1) {
                    return FutureBuilder(
                        future:
                            watch(apiRepositoryProvider).getCoinsMarketData(),
                        builder: (context, snapshot2) {
                          if (snapshot1.hasError) {
                            return Center(
                                child: Text(snapshot1.error.toString()));
                          } else if (snapshot2.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot1.error}'));
                          } else if (snapshot1.hasData &&
                              snapshot1.data.docs.length == 0) {
                            return const Center(
                                child: Text(
                              "Explore Crypto Coins...",
                              style: TextStyle(fontSize: 25.0),
                            ));

                            // if()
                          } else if (snapshot1.hasData && snapshot2.hasData) {
//--------------------------------------------------------------------------------------------

                            var data = snapshot2.data as List<dynamic>;
                            Map<String, double> priceMap = setValues(data);
//--------------------------------------------------------------------------------------------
                            List<CryptoTransaction> compiledData =
                                createNewMap(snapshot1.data.docs);
                            return ListView.builder(
                                itemCount: compiledData.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    leading: Image.network(
                                      compiledData[index].image_url,
                                      semanticLabel: "Coin Image",
                                    ),
                                    title: Text(compiledData[index].name),
                                    subtitle: Text(
                                        "${compiledData[index].count}"
                                        " Exchange Value : ₹${(priceMap[compiledData[index].name]! * compiledData[index].count).toStringAsFixed(2)}"),
                                    trailing: calculateProfit(
                                        cp: compiledData[index].purchase_price,
                                        sp: priceMap[compiledData[index].name]!,
                                        context: context),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ParticularTranscationPage(
                                            data: snapshot1.data.docs,
                                            coinName: compiledData[index].name,
                                          ),
                                        ),
                                      );

                                      // createAlertDialoge(
                                      //     context: context,
                                      //     data1: priceMap,
                                      //     data2: document);
                                    },
                                  );
                                });
                            // }).toList(),
                            // );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget calculateProfit(
      {dynamic cp, dynamic sp, required BuildContext context}) {
    final String result;
    if (cp < sp) {
      double n = sp - cp + 0.0;
      double d = cp + 0.0;
      result = ((n / d) * 100).toStringAsFixed(2);
      return Text(
        "↑ " + result + "%",
        style: const TextStyle(color: Colors.green),
      );
    } else {
      double n = cp - sp + 0.0;
      double d = cp + 0.0;
      result = ((n / d) * 100).toStringAsFixed(2);
      return Text(
        "↓ " + result + "%",
        style: const TextStyle(color: Colors.redAccent),
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

  createNewMap(dynamic input) {
    List<CryptoTransaction> coinsOwned = [];
    HashMap<String, CryptoTransaction> map = HashMap();
    for (int i = 0; i < input.length; i++) {
      if (!map.containsKey(input[i].data()['name'])) {
        CryptoTransaction temp = CryptoTransaction(
          date: input[i].data()['date'],
          count: input[i].data()['count'],
          name: input[i].data()['name'],
          image_url: input[i].data()['image_url'],
          purchase_price: input[i].data()['purchase_price'],
        );
        map[input[i].data()['name']] = temp;
      } else {
        CryptoTransaction temp = CryptoTransaction(
          date: input[i].data()['date'],
          count: input[i].data()['count'] + map[input[i].data()['name']]!.count,
          name: input[i].data()['name'],
          image_url: input[i].data()['image_url'],
          purchase_price: input[i].data()['purchase_price'] +
              (map[input[i].data()['name']]!.purchase_price -
                  input[i].data()['purchase_price']),
        );
        map[input[i].data()['name']] = temp;
      }
    }
    map.forEach((k, v) {
      coinsOwned.add(v);
    });
    return coinsOwned;
  }
}
