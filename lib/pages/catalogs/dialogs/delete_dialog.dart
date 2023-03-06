import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onlinestoredashboard/controller/ProductController.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';

import '../../../controller/CatalogController.dart';
import '../../../generated/l10n.dart';

final ProductController _productController = Get.put(ProductController());
final CatalogController _catalogController = Get.put(CatalogController());

class DeleteDialog extends StatelessWidget {
  DeleteDialog({@required this.url, @required int? index}) : super();

  String? url;
  int index = 0;

  void deleteProduct(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(S.of(context).wanttoremove),
      actions: <Widget>[
        TextButton(
            child: Text('Да'),
            onPressed: () {
              // if (object.runtimeType == Product) {
              _productController
                  .deleteActive(
                      _productController.products.value[index].id.toString())
                  .then((value) {
                _productController.fetchgetAll(
                    _catalogController.catalog.value.id.toString());

                // _catalogController.getProducts(_controller.catalog.value);
                Navigator.of(context).pop(); // Dismiss alert dialog

                // _controller.getProducts(_controller.catalog!);
              });
            }
            // },
            ),
        TextButton(
          child: Text('Нет'),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss alert dialog
          },
        ),
      ],
    );
  }
}
