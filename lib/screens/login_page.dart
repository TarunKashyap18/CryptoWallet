import 'package:crypto_wallet/screens/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../net/flutterFire.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_formfield.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_richtext.dart';
import '../widgets/bottom_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          CustomHeader(
            text: 'Log In.',
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrationPage()));
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColors.whiteshade,
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
                    child: Image.asset("assets/images/login.png"),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        child: Consumer(builder: (context, watch, child) {
                          return InkWell(
                            onTap: () async {
                              String navigate =
                                  await watch(authRepositoryProvider)
                                      .signin(email: email, pswd: password);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(showSnackBar(navigate));
                              if (navigate ==
                                  "Password Reset mail has been sent Pls check yours mails") {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyNavigationBar()));
                              }
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: AppColors.blue.withOpacity(0.7),
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  Consumer(builder: (context, watch, child) {
                    return AuthButton(
                        onTap: () async {
                          String navigate = await watch(authRepositoryProvider)
                              .signin(email: email, pswd: password);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(showSnackBar(navigate));
                          if (navigate == "Signed In") {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyNavigationBar()));
                          }
                        },
                        text: "Sign Up");
                  }),
                  CustomRichText(
                    discription: "Don't already Have an account? ",
                    text: "Sign Up",
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationPage()));
                    },
                  ),
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
