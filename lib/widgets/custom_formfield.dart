import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class CustomFormField extends StatelessWidget {
  final String headingText;
  final String hintText;
  final bool obsecureText;
  final Widget suffixIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int maxLines;

  const CustomFormField(
      {Key? key,
      required this.headingText,
      required this.hintText,
      required this.obsecureText,
      required this.suffixIcon,
      required this.textInputType,
      required this.textInputAction,
      required this.controller,
      required this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: Text(
            headingText,
            style: KTextStyle.textFieldHeading,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: AppColors.grayshade,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
              maxLines: maxLines,
              controller: controller,
              textInputAction: textInputAction,
              keyboardType: textInputType,
              obscureText: obsecureText,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: KTextStyle.textFieldHintStyle,
                  border: InputBorder.none,
                  suffixIcon: suffixIcon),
              validator: (value) {
                if (headingText == "Email") {
                  if (!EmailValidator.validate(value!) || value.isEmpty) {
                    return "Email is invalid";
                  }
                }
                if (headingText == "Password") {
                  if (value!.isEmpty) {
                    return "Password is invalid";
                  }
                  if (value.length < 6) {
                    return "Password is too week";
                  }
                }
                if (headingText == "UserName" && value!.isEmpty) {
                  return "Username is empty";
                }
                return null;
              },
            ),
          ),
        )
      ],
    );
  }
}
