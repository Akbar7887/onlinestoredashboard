import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onlinestoredashboard/controller/CatalogController.dart';

import '../../generated/l10n.dart';
import '../../models/catalogs/Catalog.dart';
import '../../models/constants/main_constant.dart';
import '../../widgets/onlineAppBar.dart';

final CatalogController _catalogController = Get.put(CatalogController());
Catalog? _catalog;
List<DropdownMenuItem<Catalog>> _catalogfordrop = [];
Catalog? dropDownValue;
final _keyForm = GlobalKey<FormState>();
List<Catalog> _catalogs = [];

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: OnlineAppBar(),
            body: Obx(() {
              return Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            child: Text(
                              "Каталог",
                              style: TextStyle(color: Colors.black),
                            ),
                          )),
                      Divider(),
                      ElevatedButton(
                        onPressed: () {
                          dropDownValue = null;
                          _catalog = null;
                          showDialogCatalog(context);
                        },
                        child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(S.of(context).add)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: TreeView(
                              nodes: createCatalogHiriarh(
                                  context, _catalogController.catalogs)))
                    ],
                  ));
            })));
  }

  List<TreeNode> createCatalogHiriarh(
      BuildContext context, List<Catalog> list) {
    return list
        .map((e) => TreeNode(
            content: InkWell(
                onTap: () {
                  _catalog = e;
                  showDialogCatalog(context);
                },
                child: Container(
                    height: 50,
                    width: 200,
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black38)),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(e.catalogname!),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: IconButton(
                                onPressed: () {
                                  _catalogController
                                      .deleteActive("doc/catalog/deleteactive", e.id!)
                                      .then((value) =>
                                          _catalogController.fetchGetAll());
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.blue,
                                  size: 15,
                                ),
                              ),
                            )
                          ],
                        )))),
            children: createCatalogHiriarh(context, e.catalogs!)))
        .toList();
  }

  getDropDownCatalogs(List<Catalog> catalogs) {
    // _catalogs = [];
    catalogs.forEach((element) {
      _catalogs.add(element);
      _catalogfordrop.add(
          DropdownMenuItem(child: Text(element.catalogname!), value: element));
      getDropDownCatalogs(element.catalogs!);
    });
  }

  Future<void> showDialogCatalog(BuildContext context) async {
    // if (_catalog == null) {
    //   dropDownValue = _catalogController.catalogs.firstWhere((element) =>
    //       _catalogController.catalogs.first.parent!.id == element.id);
    _catalogfordrop = [];
    _catalogs = [];
    getDropDownCatalogs(_catalogController.catalogs);

    if (_catalog != null) {
      if (_catalog!.parentId != null) {
        dropDownValue =
            _catalogs.firstWhere((element) => _catalog!.parentId == element.id);
      } else {
        dropDownValue = null;
      }
    }
    TextEditingController _controllercatalogName = TextEditingController();
    if (_catalog != null) {
      _controllercatalogName.text = _catalog!.catalogname!;
    } else {
      _controllercatalogName.text = "";
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: Text(S.of(context).catalog_show_diagram),
                  content: Form(
                      key: _keyForm,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: DropdownButton<Catalog>(
                                    isExpanded: true,
                                    value: dropDownValue,
                                    items: _catalogfordrop,
                                    onChanged: (value) {
                                      setState(() => dropDownValue = value);
                                    },
                                  )),
                              Container(
                                child: TextFormField(
                                  controller: _controllercatalogName,
                                  decoration: MainConstant.decoration(
                                      S.of(context).catalog),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return S.of(context).validate;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ))),
                  actions: <Widget>[
                    TextButton(
                      child: Text(S.of(context).save),
                      onPressed: () {
                        if (!_keyForm.currentState!.validate()) {
                          return;
                        }

                        if (_catalog == null) {
                          _catalog = new Catalog();
                          _catalog!.active = 'ACTIVE';
                        }
                        _catalog!.catalogname = _controllercatalogName.text;

                        _catalogController
                            .savesub("doc/catalog/savesub", _catalog!,
                                dropDownValue!.id!)
                            .then((value) {
                          _catalogController.fetchGetAll();
                          Navigator.of(dialogContext).pop();
                        });
                      },
                    ),
                    TextButton(
                      child: Text(S.of(context).cancel),
                      onPressed: () {
                        Navigator.of(dialogContext)
                            .pop(); // Dismiss alert dialog
                      },
                    ),
                  ],
                ));
      },
    );
  }
}
