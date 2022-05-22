import 'dart:async';

import 'package:crypto_wallet/screens/auth_pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../net/flutterFire.dart';
import 'security_check_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 2),
      () => {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyRoute(),
        )),
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Lottie.asset("assets/splash_screen.json", repeat: false),
    ));
  }
}

class MyRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var user = watch(authRepositoryProvider);
        if (user.getCurrentUser() == null) {
          return const RegistrationPage();
        } else {
          return const SecurityCheckPage(securityMsg: "To Unlock CryptoWallet");

          // return MaterialApp(
          //   theme: myTheme,
          //   debugShowCheckedModeBanner: false,
          //   title: 'Crypto Wallet',
          //   // home: const MyNavigationBar(),
          //   home: const SecurityCheckPage(
          //     securityMsg: 'To Unlock CryptoWallet',
          //   ),
          // );
        }
      },
    );
  }
}
