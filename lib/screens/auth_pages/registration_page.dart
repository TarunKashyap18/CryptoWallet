import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../net/flutterFire.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_formfield.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_richtext.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _userName = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordObsecure = true;
  String get userName => _userName.text.trim();
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
              text: 'Sign Up.',
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.09),
                      child: Lottie.asset("assets/signup.json"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "UserName",
                      hintText: "username",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _userName,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Email",
                      hintText: "Email",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      headingText: "Password",
                      hintText: "At least 6 Character",
                      obsecureText: _passwordObsecure,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _passwordObsecure = !_passwordObsecure;
                            });
                          }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Consumer(builder: (context, watch, child) {
                      return AuthButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              String navigate =
                                  await watch(authRepositoryProvider).signup(
                                      email: email,
                                      pswd: password,
                                      username: userName);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(showSnackBar(navigate));
                              if (navigate == "Successfully registered") {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyNavigationBar()));
                              }
                            }
                          },
                          text: "Sign Up");
                    }),
                    CustomRichText(
                      discription: 'Already Have an account? ',
                      text: 'Log In here',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    )
                  ],
                ),
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
