import 'package:crypto_wallet/net/flutterFire.dart';
import 'package:crypto_wallet/ui/bottom_navigation.dart';

import 'package:crypto_wallet/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text("Email"),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: _pswdController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text("Password"),
                    ),
                  ),
                ],
              ),
            ),
            Consumer(builder: (BuildContext context, watch, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: MaterialButton(
                  onPressed: () async {
                    String navigate = await watch(authRepositoryProvider)
                        .signup(
                            email: _emailController.text,
                            pswd: _pswdController.text);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(showSnackBar(navigate));
                    if (navigate == "Successfully registered") {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyNavigationBar()));
                    }
                  },
                  child: const Icon(
                    Icons.app_registration,
                    size: 40,
                  ),
                  // child: const Text("Register"),
                ),
              );
            }),
            const SizedBox(
              height: 40,
            ),
            const Text("Already have account "),
            TextButton(
              onPressed: () async {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  showSnackBar(String msg) {
    return SnackBar(content: Text(msg));
  }
}
