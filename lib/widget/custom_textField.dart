import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CtextField extends StatelessWidget {
  var TextValue;
  var hint;
  var txtIcon;
  var Controller;
  var OnCanged;
  TextInputType KeyType;
  String _errormassega(String str) {
    switch (hint) {
      case "Enter Your Password":
        return "Password Is Empty";
        break;
      case "Enter Your Email":
        return "Email Is Empty";
        break;
      case "Enter Your Name":
        return "Name Is Empty";
        break;
      default:
        return hint;
    }
  }

  CtextField(
      {@required this.TextValue,
      @required this.hint,
      this.txtIcon,
      this.KeyType,
      this.Controller,
      this.OnCanged});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: Controller,
      keyboardType: KeyType,
      showCursor: true,
      cursorRadius: Radius.circular(20),
      obscureText: hint == "Enter Your Password" ? true : false,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white54,
        prefixIcon: Icon(txtIcon),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: hint,
        focusColor: Colors.white54,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      onSaved: TextValue,
      onChanged: OnCanged,
      validator: (v) {
        if (v.isEmpty) {
          return (_errormassega(hint));
        } else
          return null;
      },
    );
  }
}
