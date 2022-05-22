import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../theme/app_colors.dart';
import '../../widgets/custom_formfield.dart';
import '../../net/flutterFire.dart';
import '../../theme/text_styles.dart';
import '../../widgets/custom_button.dart';

class ReAuthenticationPage extends StatefulWidget {
  const ReAuthenticationPage({Key? key}) : super(key: key);

  @override
  State<ReAuthenticationPage> createState() => _ReAuthenticationPageState();
}

class _ReAuthenticationPageState extends State<ReAuthenticationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool passwordObsecure = true;
  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.blue,
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Authenticate Yourself",
              style: KTextStyle.headerTextStyle,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.09),
                    child: Lottie.asset("assets/login.json"),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomFormField(
                    headingText: "Email",
                    hintText: "Email",
                    obsecureText: false,
                    suffixIcon: const SizedBox(),
                    controller: _emailController,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    headingText: "Password",
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    hintText: "At least 6 Character",
                    obsecureText: passwordObsecure,
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            passwordObsecure = !passwordObsecure;
                          });
                        }),
                    controller: _passwordController,
                  ),
                  Consumer(builder: (context, watch, child) {
                    return AuthButton(
                        onTap: () async {
                          String navigate = await watch(authRepositoryProvider)
                              .signin(email: email, pswd: password);
                          if (navigate == "Signed In") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                showSnackBar("Authenticated Successfully"));
                            Navigator.pop(context);
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(showSnackBar(navigate));
                        },
                        text: "Submit");
                  }),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  showSnackBar(String msg) {
    return SnackBar(content: Text(msg));
  }
}
