import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(@required this.name) : super();

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Text(this.name!, style: TextStyle(color: Colors.black, fontSize: 20));
  }
}
