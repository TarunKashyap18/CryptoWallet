import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:string_validator/string_validator.dart';
import 'package:crypto_wallet/theme/colors.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class EditNameFormPage extends StatefulWidget {
  const EditNameFormPage({Key? key}) : super(key: key);

  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                        width: 330,
                        child: Text(
                          "What's Your Name?",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                          child: SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              // Handles Form Validation for First Name
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                } else if (!isAlpha(value)) {
                                  return 'Only Letters Please';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                              controller: nameController,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer(builder: (context, watch, child) {
                      final user =
                          watch(authRepositoryProvider).getCurrentUser();
                      return Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 330,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate() &&
                                    isAlpha(nameController.text)) {
                                  user!.updateDisplayName(nameController.text);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Account name updated Successfully")));
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
