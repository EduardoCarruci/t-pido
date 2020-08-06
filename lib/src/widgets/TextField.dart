import 'package:flutter/material.dart';

import 'package:t_pido/src/utils/const.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType inputType;

  TextFieldWidget(
      {this.hintText,
      this.prefixIconData,
      this.suffixIconData,
      this.obscureText,
      this.controller,
      this.inputType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return '' + hintText.toString();
        }
        return null;
      },

      //textAlign: TextAlign.center,
      keyboardType: inputType,
      obscureText: obscureText,
      controller: controller,
      cursorColor: Utils.mediumBlue,
      style: TextStyle(
        color: Utils.mediumBlue,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Utils.mediumBlue),
        focusColor: Utils.mediumBlue,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Utils.mediumBlue),
        ),
        //labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Utils.mediumBlue,
        ),
      ),
    );
  }
}
