import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlinestoredashboard/controller/ProductController.dart';
import 'package:onlinestoredashboard/controller/UniversalController.dart';
import 'package:onlinestoredashboard/models/catalogs/ProductImage.dart';

import '../../../generated/l10n.dart';
import '../../../models/UiO.dart';

final UniversalController _universalController = Get.find();
final ProductController _productController = Get.find();
int idx = 0;
Uint8List? _webImage;

class ProductImagePart extends StatelessWidget {
  const ProductImagePart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _universalController
        .getByParentId("doc/productimage/get",
            _productController.product.value.id.toString())
        .then((value) {
      // if (value.isNotEmpty) {
      _universalController.productImages.value =
          value.map((e) => ProductImage.fromJson(e)).toList();
      // } else {}
    });
    return Obx(() => SafeArea(
            child: Container(
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
                        onPressed: () async {
                          XFile? image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            var f = await image.readAsBytes();
                            _webImage = f;

                            Map<String, dynamic> param = {
                              "id": "",
                              "parent_id": _productController.product.value.id
                                  .toString(),
                              "mainimg": false.toString()
                            };
                            _universalController.saveImage(
                                "doc/productimage/upload",
                                f,
                                param,
                                image.name);
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[800])),
                        child: Text(S.of(context).add))),
                SizedBox(
                  height: 10,
                ),

                Expanded(
                    child: _universalController.productImages.value.isEmpty
                        ? Container()
                        : ListView.builder(
                            itemCount:
                                _universalController.productImages.value.length,
                            itemBuilder: (context, inx) {
                              return Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.black26)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 5,
                                          child: InkWell(
                                              onTap: () {
                                                idx = inx;
                                              },
                                              child: Card(
                                                child: Image.network(
                                                    '${UiO.url}doc/productimage/download/${_universalController.productImages.value[inx].id}'),
                                              ))),
                                      Expanded(
                                          child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _universalController.delete(
                                              "doc/productimage/deleteimage",
                                              _universalController
                                                  .productImages.value[inx].id
                                                  .toString());
                                        },
                                      ))
                                    ],
                                  ));
                            }))

                // ListView(children: _universalController,)
              ],
            )),
            VerticalDivider(),
            Expanded(
              flex: 3,
              child: _universalController.productImages.value.isEmpty
                  ? Container()
                  : Container(
                      child: Card(
                          child: Image.network(
                              '${UiO.url}doc/productimage/download/${_universalController.productImages.value[idx].id}')),
                    ),
            )
          ],
        ))));
  }
}
