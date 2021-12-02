import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:crypto_wallet/ui/bottom_navigation.dart';
import 'package:crypto_wallet/ui/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
            const SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: MaterialButton(
                onPressed: () async {
                  String navigate = await watch(authRepositoryProvider).signin(
                      email: _emailController.text, pswd: _pswdController.text);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(showSnackBar(navigate));

                  if (navigate == "Signed In") {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyNavigationBar()));
                  }
                },
                child: const Icon(
                  Icons.login,
                  semanticLabel: "login",
                  size: 40,
                ),
                // child: const Text("Login"),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text("If you don't have account "),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const RegistrationPage()));
              },
              child: const Text("Register"),
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
