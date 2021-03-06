import 'dart:async';

import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:crypto_wallet/net/providers.dart';
import 'package:crypto_wallet/screens/update_details_pages/edit_email.dart';
import 'package:crypto_wallet/screens/update_details_pages/edit_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../theme/colors.dart';
import '../widgets/display_image.dart';
import 'auth_pages/login_page.dart';
import 'auth_pages/reAuthenticate_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextStyle txtStyle = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.blueGrey);

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          actions: [
            Consumer(builder: (context, watch, child) {
              return IconButton(
                onPressed: () {
                  watch(authRepositoryProvider).signout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                icon: const FaIcon(FontAwesomeIcons.signOutAlt),
              );
            }),
          ],
        ),
        body: Consumer(builder: (context, watch, child) {
          return StreamBuilder(
              stream: watch(authRepositoryProvider).authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  User? user = snapshot.data as User;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          InkWell(
                              onTap: () {
                                // navigateSecondPage(EditImagePage());
                              },
                              child: DisplayImage(
                                imagePath:
                                    user.photoURL ?? "assets/images/user.png",
                                onPressed: () {},
                              )),
                          const SizedBox(height: 10),
                          showBalance(watch),
                          const SizedBox(height: 10),
                          buildUserInfoDisplay(user.displayName, 'Name'),
                          buildUserInfoDisplay(user.email, 'Email'),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: 350,
                              height: 40,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Email varified : ",
                                      style: txtStyle.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  user.emailVerified
                                      ? const Icon(
                                          Icons.verified_user_rounded,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.verified_user_rounded,
                                          color: Colors.grey,
                                        ),
                                  Visibility(
                                    visible: !user.emailVerified,
                                    child: MaterialButton(
                                      onPressed: () =>
                                          user.sendEmailVerification(),
                                      child:
                                          const Text("Send verfication mail"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: glassColor,
                            child: MaterialButton(
                              child: Center(
                                child: Text(
                                  "Delete Account",
                                  style: txtStyle,
                                ),
                              ),
                              onPressed: (() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const ReAuthenticationPage();
                                })).then((something) {
                                  final deleteResult =
                                      watch(authRepositoryProvider)
                                          .deleteAccountDetails();
                                  print(deleteResult);
                                  user.delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Account deleted Successfully")));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                });
                              }),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              });
        }),
      ),
    );
  }

  Widget showBalance(ScopedReader watch) {
    const wallletTextStyle = TextStyle(
      fontSize: 20,
    );
    double balance = 0;
    return Row(
      children: [
        const Text(
          "Wallet Balance : ",
          style: wallletTextStyle,
        ),
        Text(
          watch(walletBalanceProvider).state.toStringAsFixed(2) + " ???",
          style: wallletTextStyle,
        ),
      ],
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String? getValue, String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: txtStyle.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Container(
                width: 350,
                height: 40,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.white,
                  width: 1,
                ))),
                child: InkWell(
                  onTap: () {
                    if (title == "Email") {
                      reauthenticate(const EditEmailFormPage());
                    } else {
                      navigateSecondPage(const EditNameFormPage());
                    }
                  },
                  child: Row(children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getValue!,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    )
                  ]),
                ))
          ],
        ),
      );

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void reauthenticate(Widget editForm) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ReAuthenticationPage()))
        .then((somthing) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => editForm))
          .then(onGoBack);
    });
  }
}
