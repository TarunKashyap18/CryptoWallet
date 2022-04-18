// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../model/transcation.dart';
// import 'api_methods.dart';
// import 'dart:collection';

// class DbHandler {
//   static var _dataStream;
//   static List<UserPortfolioData> userPortfolioData = [];
//   static List<CryptoTransactionHistory> listOfCoinTransaction = [];
//   static HashMap<String, double> coinPriceDataMap = HashMap();
//   static dynamic resultData = [];
//   static initDbHandler() async {
//     print("initDb Started");
//     _dataStream = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection('Transaction')
//         .snapshots()
//         .toList();
//     listOfCoinTransaction = createMapOfCoins(_dataStream);
//     coinPriceDataMap = setPrice(listOfCoinTransaction);
//     resultData = setPortfolioData(listOfCoinTransaction, coinPriceDataMap);
//     print("initDb ended");
//   }

//   static createMapOfCoins(dynamic input) {
//     HashMap<String, CryptoTransactionHistory> map = HashMap();
//     for (var item in input) {
//       print(item.data()['name'] + "\n");
//     }
//     for (var item in input) {
//       if (!map.containsKey(item.listOfCoinTransaction()['name'])) {
//         CryptoTransactionHistory temp = CryptoTransactionHistory(
//           purchase_price: item.data()['purchase_price'],
//           date: item.data()['date'],
//           units: item.data()['count'],
//           name: item.data()['name'],
//           status: item.data()['status'],
//           image_url: item.data()['image_url'],
//           id: item.data()['id'],
//         );
//         map[item.data()['name']] = temp;
//       } else {
//         CryptoTransactionHistory temp = CryptoTransactionHistory(
//           date: item.data()['date'],
//           units: item.listOfCoinTransaction()['count'] +
//               map[item.listOfCoinTransaction()['name']]!.units,
//           name: item.listOfCoinTransaction()['name'],
//           image_url: item.listOfCoinTransaction()['image_url'],
//           purchase_price: item.listOfCoinTransaction()['purchase_price'] +
//               (map[item.listOfCoinTransaction()['name']]!.purchase_price -
//                   item.listOfCoinTransaction()['purchase_price']),
//           status: item.listOfCoinTransaction()['status'],
//           id: item.listOfCoinTransaction()['id'],
//         );
//         map[item.listOfCoinTransaction()['name']] = temp;
//       }
//     }
//     List<CryptoTransactionHistory> coinsOwned = [];
//     map.forEach((k, v) {
//       coinsOwned.add(v);
//     });
//     print("initDb mapOfCoin");
//     return coinsOwned;
//   }

//   static setPortfolioData(
//       List<CryptoTransactionHistory> data, dynamic map) async {
//     List<UserPortfolioData> temp = [];
//     for (int i = 0; i < data.length; i++) {
//       var profit = ((map[data[i].name] - data[i].purchase_price) /
//               data[i].purchase_price) *
//           100;
//       temp.add(UserPortfolioData(
//         coinName: data[i].name,
//         imageUrl: data[i].image_url,
//         exchangePrice: map[data[i].name],
//         purchasePrice: data[i].purchase_price,
//         units: data[i].units,
//         profitPercentage: profit,
//       ));
//     }
//     for (var item in temp) {
//       print(item.coinName + "\n");
//     }
//     print("initDb portfolio");
//     return temp;
//   }

//   static setPrice(List<CryptoTransactionHistory> data) async {
//     HashMap<String, double> map = HashMap();
//     for (var item in data) {
//       var temp = await ApiRepository().getCoinPrice(item.id);
//       map.putIfAbsent(item.name, () => temp[item.id]['inr'].toDouble());
//     }
//     print("initDb setPrice");
//     return map;
//   }
// }
