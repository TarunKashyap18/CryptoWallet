import 'package:crypto_wallet/screens/splash_screen.dart';
import 'package:crypto_wallet/theme/colors.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final myTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: primary.withOpacity(0.3),
    ),
    primaryColor: primary,
    backgroundColor: appBgColor,
    bottomAppBarColor: bottomBarBgColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primary.withOpacity(0.3),
    ),
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      // darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Crypto Wallet',
      home: const SplashScreen(),
    );
  }
}
