import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'avatar_image.dart';

class CoinCard extends StatelessWidget {
  final String image;
  // final String priceChange;
  final String name;
  final String units;
  final String todayPrice;
  final Widget profit;
  const CoinCard({
    Key? key,
    this.profit = const Text(""),
    required this.todayPrice,
    required this.image,
    // required this.priceChange,
    required this.name,
    required this.units,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: glassColor.withOpacity(0.4),
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
        children: [
          Row(
            children: [
              AvatarImage(
                image,
                isSVG: false,
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Text(
                name,
                overflow: TextOverflow.fade,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              )),
              Align(
                alignment: Alignment.centerRight,
                child: Text("Units: " + units),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today Price: " + todayPrice,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  // profit,
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  decoration: BoxDecoration(
                      color: primary.withAlpha(40),
                      borderRadius: BorderRadius.circular(30)),
                  child: profit)
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Sell"),
                  Icon(Icons.sell_rounded),
                ],
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
