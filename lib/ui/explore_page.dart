import 'package:crypto_wallet/net/api_methods.dart';
import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_page.dart';

class ExplorePage extends ConsumerWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // ignore: unused_local_variable
    Future<List> getData;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
        actions: [
          IconButton(
              onPressed: () {
                watch(authRepositoryProvider).signout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.signOutAlt)),
        ],
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getData = watch(apiRepositoryProvider).getCoinsMarketData();
        },
        child: FutureBuilder(
            future: watch(apiRepositoryProvider).getCoinsMarketData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                var data = snapshot.data as List<dynamic>;
                // return Text(data.elementAt(1).toString());
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.network(
                            data.elementAt(index)['image'],
                            fit: BoxFit.contain,
                          ),
                          title: Text(data.elementAt(index)['name']),
                          subtitle: Text("₹" +
                              data
                                  .elementAt(index)['current_price']
                                  .toString()),
                          trailing: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.cartPlus,
                            ),
                            onPressed: () {
                              createAlertDialoge(
                                  context, data.elementAt(index), watch);
                            },
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  createAlertDialoge(
      BuildContext context, Map<String, dynamic> data, ScopedReader watch) {
    TextEditingController _amountController = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: Text(data['name']),
      content: TextFormField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          label: Text("Amount"),
          // focusedBorder: InputBorder(borderSide: BorderSide.)
        ),
      ),
      actions: [
        // ignore: deprecated_member_use
        FlatButton(
            onPressed: () {
              watch(authRepositoryProvider).addCoin(
                amount: _amountController.text.trim(),
                price: data['current_price'].toString(),
                imageUrl: data['image'],
                name: data['name'],
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(data['name'] + " Successfully Purchased")));
              Navigator.of(context).pop();
            },
            child: const Text("Buy"))
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
