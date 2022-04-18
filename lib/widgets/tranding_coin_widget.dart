import 'package:crypto_wallet/net/api_methods.dart';
import 'package:flutter/material.dart';

import 'coin_slider.dart';

class ShowTrandingCoin extends StatefulWidget {
  const ShowTrandingCoin({Key? key}) : super(key: key);

  @override
  State<ShowTrandingCoin> createState() => _ShowTrandingCoinState();
}

class _ShowTrandingCoinState extends State<ShowTrandingCoin> {
  late final _data;
  @override
  initState() {
    _data = ApiRepository().getTrandingCoins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("indirect : " + _data.runtimeType.toString());
    // print("direct : " +
    //     ApiRepository().getTrandingCoins().runtimeType.toString());
    return Container(
      child: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: " + snapshot.error.toString() + " 😥");
            } else if (snapshot.hasData) {
              // print(snapshot.data);
              return TrandingCoinSlider(balanceCards: snapshot.data);
              // return const Text("");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            } else {
              return const Text("No data available 🙂");
            }
          }),
    );
  }
}
