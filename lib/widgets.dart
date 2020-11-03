import 'package:flutter/material.dart';

InputDecoration textFieldDecor(String hintText, IconData preIcon) {
  return InputDecoration(
    prefixIcon: Icon(
      preIcon,
      color: Color(0xff37ebea),
    ),
    hintText: hintText,
    hintStyle: TextStyle(color: Color(0xff37ebea)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff37ebea))),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xff37ebea)),
    ),
  );
}
