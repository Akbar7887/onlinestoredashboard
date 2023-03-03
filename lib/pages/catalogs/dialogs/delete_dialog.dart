import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';

import '../../../controller/CatalogController.dart';
import '../../../generated/l10n.dart';

final CatalogController _controller = Get.put(CatalogController());

class DeleteDialog extends StatelessWidget {
  DeleteDialog({@required this.url,
    @required dynamic object,
    @required int? index}) : super();

  String? url;
  dynamic object;
  int index = 0;

  void deleteProduct(BuildContext context) {
    _controller
        .deleteById(url, _controller.productlist.value[index].id.toString())
        .then((value) {
      _controller.fetchGetAll();
      _controller.getProducts(object!);
      Navigator.of(context).pop(); // Dismiss alert dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AlertDialog(
      content: Text(S.of(context).wanttoremove),
      actions: <Widget>[
        TextButton(
          child: Text('Да'),
          onPressed: () {
            if (object.runtimeType == Product) {
              deleteProduct(context);
            }

          },
        ),
        TextButton(
          child: Text('Нет'),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss alert dialog
          },
        ),
      ],
    ));
  }
}
