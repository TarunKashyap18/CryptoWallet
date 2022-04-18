import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_wallet/widgets/balance_card.dart';
import 'package:flutter/material.dart';

class TrandingCoinSlider extends StatelessWidget {
  const TrandingCoinSlider({Key? key, required this.balanceCards})
      : super(key: key);
  final balanceCards;

  @override
  Widget build(BuildContext context) {
    List<Widget> trandingCoindWidgetList = [];
    var tempData = balanceCards['coins'];
    for (var element in tempData) {
      // trandingCoindWidgetList.add(Text(element['item'].toString()));
      trandingCoindWidgetList.add(BalanceCard(data: element['item']));
    }
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        disableCenter: true,
        height: 150,
        viewportFraction: 1,
      ),
      items: trandingCoindWidgetList,
    );
  }
}
