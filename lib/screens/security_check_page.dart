import 'package:crypto_wallet/net/local_auth.dart';
import 'package:crypto_wallet/theme/colors.dart';
import 'package:crypto_wallet/widgets/bottom_navigation.dart';
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';

class SecurityCheckPage extends StatefulWidget {
  final String securityMsg;
  const SecurityCheckPage({Key? key, required this.securityMsg})
      : super(key: key);

  @override
  State<SecurityCheckPage> createState() => _SecurityCheckPageState();
}

class _SecurityCheckPageState extends State<SecurityCheckPage> {
  bool check = false;
  @override
  initState() {
    super.initState();
    initAuthenticate();
  }

  initAuthenticate() async {
    var temp = await LocalAuthApi.authenticate(widget.securityMsg);
    setState(() {
      check = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (check) {
      return const MyNavigationBar();
    } else {
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
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      child: Lottie.asset("assets/fingerprint-scanning.json",
                          width: 300, height: 300)),
                  widget.securityMsg == "To Unlock CryptoWallet"
                      ? RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(fontSize: 15),
                            children: [
                              TextSpan(text: "Please authenticate"),
                              TextSpan(
                                  text: "\nTo sigin CryptoWallet application"),
                            ],
                          ),
                        )
                      : const Text(
                          "Please authenticate for payment option",
                          style: TextStyle(fontSize: 20),
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                    color: glassColor,
                    child: MaterialButton(
                      child: const Text(
                        "Authorize now",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        final check =
                            await LocalAuthApi.authenticate(widget.securityMsg);
                        if (check &&
                            widget.securityMsg == "To Unlock CryptoWallet") {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyNavigationBar()));
                        }
                        if (check && widget.securityMsg == "") {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
