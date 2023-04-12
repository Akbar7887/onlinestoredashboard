import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import '../../generated/l10n.dart';
import '../../models/UiO.dart';
import '../../models/catalogs/Catalog.dart';
import '../../models/constants/main_constant.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final Controller _controller = Get.put(Controller());

// Catalog? _catalog;
  List<DropdownMenuItem<Catalog>> _catalogfordrop = [];
  Catalog? dropDownValue;
  final _keyForm = GlobalKey<FormState>();
  FlutterSecureStorage _storage = FlutterSecureStorage();
  String? _token;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future<void> getToken() async {
    _token = await _storage.read(key: "token");
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
          child: Card(
              child: SingleChildScrollView(
                  child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              child: SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      dropDownValue = null;
                      // _catalog = null;
                      _controller.catalog = Catalog().obs;
                      showDialogCatalog(context);
                    },
                    child: FittedBox(
                        fit: BoxFit.fitWidth, child: Text(S.of(context).add)),
                  ))),
          SizedBox(
            height: 10,
          ),
          Container(
              child: TreeView(
                  nodes: createCatalogHiriarh(context, _controller.catalogs)))
        ],
      ))));
    });
  }

  List<TreeNode> createCatalogHiriarh(
      BuildContext context, List<Catalog> list) {
    return list
        .map((e) => TreeNode(
            content: InkWell(
                onTap: () {
                  _controller.catalog.value = e;
                  showDialogCatalog(context);
                },
                child: Container(
                    height: 62,
                    width: MediaQuery.of(context).size.width / 4,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.black38)),
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  child: Text(
                                    e.catalogname!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),

                              // Spacer(),

                              Container(
                                  child: IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  XFile? image = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    var f = await image.readAsBytes();

                                    Map<String, dynamic> param = {
                                      "id": e.id.toString()
                                    };
                                    _controller.saveImage("doc/catalog/upload",
                                        f, param, image.name);
                                  }
                                },
                              )),
                              Container(
                                  child: Image.network(
                                      "${UiO.url}doc/catalog/download/${e.id.toString()}",
                                      headers: {
                                    "Authorization":
                                        "Bearer ${_token}"
                                  }, errorBuilder: (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) {
                                return Icon(
                                  Icons.photo,
                                  color: Colors.blue,
                                );
                              })),
                              Padding(
                                padding: EdgeInsets.only(right: 1),
                                child: IconButton(
                                  onPressed: () {
                                    _controller
                                        .deleteActive(
                                            "doc/catalog/deleteactive", e.id!)
                                        .then((value) =>
                                            _controller.fetchGetAll());
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ))),
            children: createCatalogHiriarh(context, e.catalogs!)))
        .toList();
  }

  dropDownTree(List<Catalog> catalogs) {
    catalogs.forEach((element) {
      _controller.catalogslist.add(element);
      _catalogfordrop.add(DropdownMenuItem(
          child: TreeView(nodes: [
            TreeNode(
                content: Text(element.catalogname!),
                children: getDropDownCatalogs(element.catalogs!)),
          ]),
          value: element));
    });
  }

  getDropDownCatalogs(List<Catalog> catalogs) {
    // _catalogs = [];
    catalogs.forEach((element) {
      _controller.catalogslist.value.add(element);
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
    _controller.catalogslist.value = [];
    getDropDownCatalogs(_controller.catalogs);

    if (_controller.catalog.value != null) {
      if (_controller.catalog.value.parent != null) {
        dropDownValue = _controller.catalogslist.value.firstWhere(
            (element) => _controller.catalog.value!.parent!.id == element.id);
      } else {
        dropDownValue = null;
      }
    }
    TextEditingController _controllercatalogName = TextEditingController();
    if (_controller.catalog.value.catalogname != null) {
      _controllercatalogName.text = _controller.catalog.value.catalogname!;
    } else {
      _controllercatalogName.clear();
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: Text(S.of(context).form_dialog),
                  content: Form(
                      key: _keyForm,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          child: ListView(
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

                        _controller.catalog.value.catalogname =
                            _controllercatalogName.text;
                        _controller.catalog.value.parent = dropDownValue;

                        if (_controller.catalog.value.parent == null) {
                          _controller
                              .save(
                                  "doc/catalog/save", _controller.catalog.value)
                              .then((value) {
                            _controller.catalog.value = Catalog.fromJson(value);
                            _controller.fetchGetAll();
                            Navigator.of(dialogContext).pop();
                          });
                        } else {
                          _controller
                              .savesub("doc/catalog/savesub",
                                  _controller.catalog.value, dropDownValue!.id!)
                              .then((value) {
                            _controller.fetchGetAll();
                            Navigator.of(dialogContext).pop();
                          });
                        }
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
