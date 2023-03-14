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

final Controller _controller = Get.put(Controller());

class ProductImagePart extends StatelessWidget {
  const ProductImagePart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
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
                            if (_controller.productImages.isNotEmpty) {
                              _controller.productImage.value =
                                  _controller.productImages.value[0];
                            }
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
                                    border: Border.all(color: Colors.black26)),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: InkWell(
                                            onTap: () {
                                              _controller.productImage.value =
                                                  _controller
                                                      .productImages.value[inx];
                                            },
                                            child: Card(
                                              child: Image.network(
                                                  '${UiO.url}doc/productimage/download/${_controller.productImages.value[inx].id}'),
                                            ))),
                                    Container(
                                        height: 200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                child: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                _controller.deleteById(
                                                    "doc/productimage/deleteimage",
                                                    _controller.productImages
                                                        .value[inx].id
                                                        .toString());
                                              },
                                            )),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                                child: Checkbox(
                                              // checkColor: Colors.black,
                                              // fillColor:
                                              //     MaterialStateProperty.all(
                                              //         Colors.black),
                                              value: _controller
                                                  .productImages[inx].mainimg,
                                              onChanged: (newvalue) {
                                                _controller
                                                    .productImages
                                                    .value[inx]
                                                    .mainimg = newvalue;

                                                _controller.productImage.value =
                                                    _controller.productImages
                                                        .value[inx];
                                                _controller.productImage.value
                                                        .product =
                                                    _controller.product.value;
                                                _controller
                                                    .save(
                                                        "doc/productimage/save",
                                                        _controller
                                                            .productImage.value)
                                                    .then((value) {
                                                       print(value);
                                                       _controller.productImages.refresh();
                                                  // ProductImage productimage =
                                                  //     ProductImage.fromJson(
                                                  //         value);
                                                  //
                                                  // _controller.productImages
                                                  //     .forEach((element) {
                                                  //   if (element.id ==
                                                  //       productimage.id) {
                                                  //     element == productimage;
                                                  //   }
                                                  // });
                                                });
                                              },
                                            ))
                                          ],
                                        ))
                                  ],
                                ));
                          }))

              // ListView(children: _universalController,)
            ],
          )),
          // VerticalDivider(),
          Expanded(
            flex: 3,
            child: _controller.productImages.value.isEmpty
                ? Container()
                : Container(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.white),
                        ),
                        child: Image.network(
                            '${UiO.url}doc/productimage/download/${_controller.productImage.value.id}')),
                  ),
          )
        ],
      )));
    });
  }
}
