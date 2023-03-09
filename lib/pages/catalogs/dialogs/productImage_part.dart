import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onlinestoredashboard/controller/UniversalController.dart';

import '../../../generated/l10n.dart';

final UniversalController _universalController = Get.find();

class ProductImagePart extends StatelessWidget {
  const ProductImagePart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
            child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () async {

                    },
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.grey[800])),
                    child: Text(S.of(context).add))),
            SizedBox(
              height: 10,
            ),
            // ListView(children: _universalController,)
          ],
        )));
  }
}

