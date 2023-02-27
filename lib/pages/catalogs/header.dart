import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(@required this.name) : super();

  final String? name;
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [

      SizedBox(
        height: 20,
      ),
      Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          child: FittedBox(
            child: Text(
              this.name!,
              style: TextStyle(color: Colors.black),
            ),
          )),
      Divider(),
    ],));
  }
}
