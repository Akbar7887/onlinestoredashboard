import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import 'package:onlinestoredashboard/models/catalogs/ProductImage.dart';

import '../../../generated/l10n.dart';
import '../../../models/UiO.dart';

final Controller _controller = Get.find();
int idx = 0;
Uint8List? _webImage;

class ProductImagePart extends StatelessWidget {
  const ProductImagePart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                              "parent_id":
                                  _controller.product.value.id.toString(),
                              "mainimg": false.toString()
                            };
                            _controller
                                .saveImage("doc/productimage/upload", f, param,
                                    image.name)
                                .then((value) {
                              ProductImage productimage =
                                  ProductImage.fromJson(value);
                              _controller.productImages.add(productimage);
                              _controller.productImages.refresh();
                            });
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
                    child: _controller.productImages.value.isEmpty
                        ? Container()
                        : ListView.builder(
                            itemCount: _controller.productImages.value.length,
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
                                                    '${UiO.url}doc/productimage/download/${_controller.productImages.value[inx].id}'),
                                              ))),
                                      Expanded(
                                          child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _controller.deleteById(
                                              "doc/productimage/deleteimage",
                                              _controller
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
              child: _controller.productImages.value.isEmpty
                  ? Container()
                  : Container(
                      child: Card(
                          child: Image.network(
                              '${UiO.url}doc/productimage/download/${_controller.productImages.value[idx].id}')),
                    ),
            )
          ],
        ))));
  }
}
