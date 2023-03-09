import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onlinestoredashboard/controller/ProductController.dart';
import 'package:onlinestoredashboard/controller/UniversalController.dart';
import 'package:onlinestoredashboard/models/catalogs/ProductImage.dart';

import '../../../generated/l10n.dart';
import '../../../models/UiO.dart';

final UniversalController _universalController = Get.find();
final ProductController _productController = Get.find();
int idx = 0;

class ProductImagePart extends StatelessWidget {
  const ProductImagePart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _universalController
        .getByParentId("doc/productimage/get",
            _productController.product.value.id.toString())
        .then((value) {
      _universalController.productImages.value =
          value.map((e) => ProductImage.fromJson(e)).toList();
    });
    return Obx(() => SafeArea(
            child: Row(
          children: [
            Expanded(
                child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                        onPressed: () async {},
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[800])),
                        child: Text(S.of(context).add))),
                SizedBox(
                  height: 10,
                ),

                Expanded(
                    child: ListView.builder(
                        itemCount:
                            _universalController.productImages.value.length,
                        itemBuilder: (context, inx) {
                          return Container(
                              child: InkWell(
                                  onTap: () {
                                    idx = inx;
                                  },
                                  child: Card(
                                    child: Image.network(
                                        '${UiO.url}doc/productimage/download/${_universalController.productImages.value[inx].id}'),
                                  )));
                        }))

                // ListView(children: _universalController,)
              ],
            )),
            VerticalDivider(),
            Expanded(
              flex: 3,
              child: Container(
                child: Card(
                    child: Image.network(
                        '${UiO.url}doc/productimage/download/${_universalController.productImages.value[idx].id}')),
              ),
            )
          ],
        )));
  }
}
