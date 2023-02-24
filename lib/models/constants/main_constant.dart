import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainConstant{

 static InputDecoration decoration(String name) {
    return InputDecoration(
        fillColor: Colors.white,
        //Theme.of(context).backgroundColor,
        labelText: name,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0.5, color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0.5, color: Colors.black)));
  }
}