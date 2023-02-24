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
List<DropdownMenuItem<Catalog>> catalogfordrop = [];
Catalog? dropDownValue;

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: OnlineAppBar(),
            body: Obx(() {
              return ListView(
                children: [
                  Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: Text(
                          "Каталог",
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  Container(
                      child: TreeView(
                          nodes: createCatalogHiriarh(
                              context, _catalogController.catalogs)))
                ],
              );
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
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.black38)),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(e.catalogname!)),
                    ))),
            children: createCatalogHiriarh(context, e.catalogs!)))
        .toList();
  }

  List<DropdownMenuItem<Catalog>> getDropDownCatalogs() {
    return _catalogController.catalogs
        .map<DropdownMenuItem<Catalog>>((element) {
      return DropdownMenuItem(
          child: Text(element.catalogname!), value: element);
       // getDropDownCatalogs();
    }).toList();
  }

  Future<void> showDialogCatalog(BuildContext context) async {
    if (_catalogController.catalogs != null) {
      dropDownValue = _catalogController.catalogs.first;
    }
    TextEditingController _catalogName = TextEditingController();
    if (_catalog != null) {
      _catalogName.text = _catalog!.catalogname!;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: Text(S.of(context).catalog_show_diagram),
                  content: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: dropDownValue == null
                                  ? CircularProgressIndicator()
                                  : DropdownButton<Catalog>(
                                      isExpanded: true,
                                      value: dropDownValue,
                                      items: getDropDownCatalogs(),
                                      onChanged: (value) {
                                        setState(() => dropDownValue = value);
                                      },
                                    )),
                          Container(
                            child: TextFormField(
                              controller: _catalogName,
                              decoration: MainConstant.decoration(
                                  S.of(context).catalog),
                            ),
                          ),
                        ],
                      )),
                  actions: <Widget>[
                    TextButton(
                      child: Text(S.of(context).save),
                      onPressed: () {
                        Navigator.of(dialogContext)
                            .pop(); // Dismiss alert dialog
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
