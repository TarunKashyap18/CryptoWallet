import 'package:crypto_wallet/theme/colors.dart';

import 'widgets/bottom_navigation.dart';
import '../screens/registration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'net/flutterfire.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var user = watch(authRepositoryProvider);
    if (user.getCurrentUser() == null) {
      return MaterialApp(
        theme: ThemeData(
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
        ),
        // darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: 'Crypto Wallet',
        home: const RegistrationPage(),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: primary.withOpacity(0.9),
          ),
          primaryColor: primary,
          backgroundColor: appBgColor,
          bottomAppBarColor: bottomBarBgColor,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: primary.withOpacity(0.3),
          ),
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Crypto Wallet',
        home: const MyNavigationBar(),
      );
    }
  }
}
