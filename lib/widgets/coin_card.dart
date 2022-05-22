import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:string_validator/string_validator.dart';
import '../net/flutterFire.dart';
import '../theme/colors.dart';
import 'avatar_image.dart';

class CoinCard extends StatelessWidget {
  final String image;
  // final String priceChange;
  final String name;
  final String units;
  final String todayPrice;
  final String id;
  final Widget profit;
  const CoinCard({
    Key? key,
    this.profit = const Text(""),
    required this.todayPrice,
    required this.image,
    // required this.priceChange,
    required this.name,
    required this.id,
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
          Consumer(builder: (context, watch, child) {
            return Align(
              alignment: Alignment.center,
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Sell"),
                    Icon(Icons.sell_rounded),
                  ],
                ),
                onTap: () {
                  Map<String, dynamic> temp = {
                    'name': name,
                    'today_price': todayPrice,
                    'units': units,
                    'image': image,
                    'id': id,
                  };
                  createAlertDialoge(context, temp, watch);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  createAlertDialoge(
      BuildContext context, Map<String, dynamic> data, ScopedReader watch) {
    TextEditingController _amountController = TextEditingController();
    double currencyPrice =
        toDouble(data['units']) * toDouble(data['today_price']);
    AlertDialog alert = AlertDialog(
      title: Center(child: Text(data['name'])),
      content: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Current Price : $currencyPrice"),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text("Amount"),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                print("sell units: " + _amountController.text.trim());
                print("sell units price: " + data['today_price']);
                if (toDouble(_amountController.text.trim()) <= currencyPrice) {
                  final result = await watch(authRepositoryProvider).sellCoin(
                    amount: _amountController.text.trim(),
                    price: data['today_price'].toString(),
                    imageUrl: data['image'],
                    name: data['name'],
                    id: data['id'],
                  );
                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(data['name'] + " Successfully Selled")));
                    Navigator.of(context).pop();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(" Incorrect Value ")));
                }
              },
              child: const Text("Sell"),
            )
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
