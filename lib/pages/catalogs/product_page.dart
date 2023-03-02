import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinestoredashboard/controller/CatalogController.dart';
import 'package:onlinestoredashboard/models/UiO.dart';
import 'package:onlinestoredashboard/models/catalogs/Catalog.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';
import 'package:onlinestoredashboard/models/constants/main_constant.dart';
import 'package:onlinestoredashboard/pages/catalogs/addcharacteristic.dart';
import 'package:onlinestoredashboard/pages/catalogs/header.dart';
import 'package:onlinestoredashboard/widgets/onlineAppBar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../generated/l10n.dart';

final CatalogController _controller = Get.put(CatalogController());

Product? _product;
late ProductDataGridSource _productDataGridSource;
final _keyForm = GlobalKey<FormState>();
Catalog? dropDownValue;

class ProductPage extends GetView<CatalogController> {
  ProductPage() : super();

  Widget tree(BuildContext context, List<Catalog> catalogs) {
    return Container(
        child: Card(
            child: Column(
      children: [
        Container(
            height: 20,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(
                S.of(context).catalog,
              ),
            )),
        Divider(),
        Expanded(child: TreeView(nodes: treeList(context, catalogs)))
      ],
    )));
  }

  List<TreeNode> treeList(BuildContext context, List<Catalog> list) {
    return list
        .map((e) => TreeNode(
            content: InkWell(
                onTap: () {
                  _controller.getProducts(e);
                  dropDownValue = e;

                  _productDataGridSource =
                      ProductDataGridSource(_controller.productlist.value);
                },
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 10,
                    //constraints: BoxConstraints.expand(),
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black38)),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(5),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Text(
                                    e.catalogname!,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                            Spacer(),
                          ],
                        )))),
            children: treeList(context, e.catalogs!)))
        .toList();
  }

  Widget table(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    height: 20,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        S.of(context).product,
                      ),
                    )),
                Divider(),
                Container(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                        onPressed: () {
                          _product = null;
                          dropDownValue = null;
                          showDialogMeneger(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[800])),
                        child: Text("Добавить"))),
                SizedBox(
                  height: 20,
                ),
                SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: Colors.grey[700],
                    rowHoverColor: Colors.grey,
                    gridLineStrokeWidth: 1,
                    rowHoverTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  child: SfDataGrid(
                      source: _productDataGridSource,
                      selectionMode: SelectionMode.single,
                      headerGridLinesVisibility: GridLinesVisibility.vertical,
                      columnWidthMode: ColumnWidthMode.fill,
                      // allowFiltering: true,
                      allowSorting: true,
                      allowEditing: true,
                      gridLinesVisibility: GridLinesVisibility.both,
                      onQueryRowHeight: (details) {
                        return UiO.datagrig_height;
                      },
                      headerRowHeight: UiO.datagrig_height,
                      onCellTap: (cell) {
                        // if (cell.rowColumnIndex.rowIndex > -1) {
                        //   if (cell.rowColumnIndex.columnIndex == 2) {
                        //
                        //   }
                        //   if (cell.rowColumnIndex.columnIndex == 3) {}
                        //   if (cell.rowColumnIndex.columnIndex == 4) {
                        //     // deleterow(context, cell);
                        //   }
                        // }
                      },
                      columns: [
                        GridColumn(
                            columnName: 'id',
                            width: 50,
                            label: Center(
                              child: Text(
                                "№",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        GridColumn(
                          columnName: 'name',
                          // width: MediaQuery.of(context).size.width/2,
                          label: Center(
                            child: Text(
                              S.of(context).name,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                            columnName: "delete",
                            maximumWidth: 150,
                            label: Container(
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.center,
                                child: Icon(Icons.menu))),
                      ]),
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // _controller.getProducts(_controller.catalogs.value.first);
      _productDataGridSource = ProductDataGridSource(_controller.productlist);

      return SafeArea(
          child: Scaffold(
        appBar: OnlineAppBar(), // extendBodyBehindAppBar: true,
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ListView(children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                S.of(context).product_page_name,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: UiO.font,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade800)),
                child: Row(
                  children: [
                    Expanded(child: tree(context, _controller.catalogs)),
                    Expanded(flex: 3, child: table(context)),
                  ],
                ))
          ]),
        ),
        // drawer: DskNavigationDrawer(),

        // drawer: DskNavigationDrawer(),
      ));
    });
  }
}

Future<void> showDialogMeneger(BuildContext context) async {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _id = '';
  if (_product != null) {
    _nameController.text = _product!.name!;
    _descriptionController.text = _product!.description!;
    _id = _product!.id.toString();
  } else {
    _id = '';
    _nameController.clear();
    _descriptionController.clear();
  }

  return await showDialog<void>(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
                title: Text(S.of(context).catalog_show_diagram),
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Form(
                        key: _keyForm,
                        child: Column(
                          children: [
                            DropdownButton(
                              isExpanded: true,
                              items: _controller.catalogslist.value.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e.catalogname!),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => dropDownValue = value);
                              },
                              value: dropDownValue,
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text('№ ${_id}')),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).validate;
                                  }
                                },
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black),
                                decoration: MainConstant.decoration(
                                    S.of(context).name)),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                controller: _descriptionController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).validate;
                                  }
                                },
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black),
                                decoration: MainConstant.decoration(
                                    S.of(context).description)),
                          ],
                        ))),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (!_keyForm.currentState!.validate()) {
                        return;
                      }

                      if (_product == null) {
                        _product = Product();
                      }
                      _product!.name = _nameController.text;
                      _product!.description = _descriptionController.text;
                      _controller
                          .saveProduct("doc/catalog/saveproduct", _product!,
                              dropDownValue!.id!)
                          .then((value) {
                        _controller.fetchGetAll();
                        Navigator.of(dialogContext)
                            .pop(); // Dismiss alert dialog
                      });
                    },
                    child: Text(S.of(dialogContext).save),
                  ),
                  TextButton(
                    child: Text(S.of(dialogContext).cancel),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    },
                  ),
                ],
              ));
    },
  );
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(List<Product> products) {
    dataGridRows = products
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'id',
                  value: _controller.productlist.value.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<Icon>(
                  columnName: 'delete', value: Icon(Icons.more_vert_outlined)),
            ]))
        .toList();
  }

  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  deleterow(BuildContext context, int index) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Text(S.of(context).wanttoremove),
          actions: <Widget>[
            TextButton(
              child: Text('Да'),
              onPressed: () {
                _controller
                    .deleteById("doc/product/delete",
                        _controller.productlist.value[index].id.toString())
                    .then((value) {
                  _controller.fetchGetAll();
                  _controller.getProducts(dropDownValue!);
                });
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            TextButton(
              child: Text('Нет'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row
            .getCells()
            .map((e) => e.columnName == 'delete'
                ? Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(horizontal: 16),
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          onTap: () async {
                            _product = _controller
                                .productlist.value[dataGridRows.indexOf(row)];
                            await showDialogMeneger(context);
                          },
                          child: Icon(
                            Icons.add,
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            _controller.product.value = _controller
                                .productlist.value[dataGridRows.indexOf(row)];
                            _controller
                                .getCharasteristic(
                                    "doc/characteristic/get",
                                    _controller.productlist
                                        .value[dataGridRows.indexOf(row)].id
                                        .toString())
                                .then((value) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Addcharacteristic();
                                  });
                            });
                          },
                          child: Icon(Icons.add_comment),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            deleterow(context, dataGridRows.indexOf(row));
                          },
                          child: Icon(
                            Icons.delete,
                          ),
                        ),
                      ],
                    ))
                : Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(e.value.toString())))
            .toList());
  }
}
