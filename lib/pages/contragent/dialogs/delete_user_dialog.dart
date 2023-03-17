import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';
import '../../../generated/l10n.dart';

final Controller _controller = Get.put(Controller());

class DeleteUserDialog extends StatelessWidget {
  DeleteUserDialog({@required this.url, @required int? index}) : super();

  String? url;
  int index = 0;

  void deleteUser(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(S.of(context).wanttoremove),
      actions: <Widget>[
        TextButton(
            child: Text('Да'),
            onPressed: () {
              //     _controller
              //         .deleteById(
              //         "doc/user/delete",
              //         _controller.users[_controller.dataGridRows.indexOf(row)].id
              //             .toString())
              //         .then((value) {
              //       _controller.users.removeAt(_controller.dataGridRows.indexOf(row));
              //     });
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
