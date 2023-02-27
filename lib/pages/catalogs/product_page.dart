import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinestoredashboard/controller/CatalogController.dart';
import 'package:onlinestoredashboard/models/UiO.dart';
import 'package:onlinestoredashboard/models/catalogs/Catalog.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';
import 'package:onlinestoredashboard/pages/catalogs/header.dart';
import 'package:onlinestoredashboard/widgets/onlineAppBar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../generated/l10n.dart';

final CatalogController _controller = Get.put(CatalogController());
List<Catalog> _catalogs = [];
Catalog? _catalog;
List<Product> _products = [];
Product? _product;
late ProductDataGridSource _productDataGridSource;
final _keyForm = GlobalKey<FormState>();

class ProductPage extends GetView<CatalogController> {
  ProductPage() : super();

  getCatalogAndProduct(List<Catalog> catalogs) {
    if (catalogs.length > 0) {
      _catalogs = catalogs;
      _controller.catalogs.forEach((catalog) {
        catalog.products!.forEach((product) {
          _products.add(product);
        });
        getProduct(catalog.catalogs!);
      });
    }
  }

  getProduct(List<Catalog> catalog) {
    catalog.forEach((catalog) {
      catalog.products!.forEach((product) {
        _products.add(product);
      });
      getProduct(catalog.catalogs!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _products = [];
      getCatalogAndProduct(_controller.catalogs);

      _productDataGridSource = ProductDataGridSource(_products);
      Widget table() {
        return Card(
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: SfDataGridTheme(
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
                      onCellTap: (cell) async {
                        if (cell.rowColumnIndex.rowIndex > -1) {
                          if (cell.rowColumnIndex.columnIndex == 2) {
                            _product =
                                _products[cell.rowColumnIndex.rowIndex - 1];
                            showDialogMeneger(context);
                          }
                          if (cell.rowColumnIndex.columnIndex == 3) {
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
                                            .deleteById(
                                                "catalog/delete",
                                                _products[cell.rowColumnIndex
                                                            .rowIndex -
                                                        1]
                                                    .id
                                                    .toString())
                                            .then((value) {
                                          _controller.fetchGetAll();
                                        });
                                        Navigator.of(dialogContext)
                                            .pop(); // Dismiss alert dialog
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Нет'),
                                      onPressed: () {
                                        Navigator.of(dialogContext)
                                            .pop(); // Dismiss alert dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
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
                            columnName: "edit",
                            maximumWidth: 150,
                            label: Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  S.of(context).edit,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: "delete",
                            maximumWidth: 150,
                            label: Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  S.of(context).delete,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))),
                      ]),
                )));
      }

      List<TreeNode> treeList(List<Catalog> list) {
        return list
            .map((e) => TreeNode(
                content: InkWell(
                    onTap: () {
                      
                      _catalogs = _catalogs.where((element) => element.id == e.id).toList();
                      getCatalogAndProduct(_catalogs);
                      _controller.fetchGetAll();
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
                              
                              ],
                            )))),
                children: treeList(e.catalogs!)))
            .toList();
      }

      Widget tree() {
        return TreeView(nodes: treeList(_catalogs));
      }

      return _products.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Scaffold(
              appBar: OnlineAppBar(), // extendBodyBehindAppBar: true,
              body: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ListView(children: [
                  Header(S.of(context).product_page_name),
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
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                          onPressed: () {
                            _product = null;
                            showDialogMeneger(context);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[800])),
                          child: Text("Добавить"))),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue.shade800)),
                      child: Row(
                        children: [
                          Expanded(child:  tree()),
                          Expanded(
                              flex: 3,
                              child: table()),
                        ],
                      ))
                ]),
              ),
              // drawer: DskNavigationDrawer(),

              // drawer: DskNavigationDrawer(),
            ));
    });
  }

  Future<void> showDialogMeneger(BuildContext context) async {
    TextEditingController _nameController = TextEditingController();
    String _id = '';
    if (_product != null) {
      _nameController.text = _product!.name!;
      _id = _product!.id.toString();
    } else {
      _id = '';
      _nameController.text = '';
    }

    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).catalog_show_diagram),
          content: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 3,
              child: Form(
                  key: _keyForm,
                  child: Column(
                    children: [
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
                              return "Просим заплнить наименование";
                            }
                          },
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              //Theme.of(context).backgroundColor,
                              labelText: S.of(context).name,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 0.5, color: Colors.black)))),
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
                _controller
                    .saveProduct("doc/catalog/saveproduct", _product!, 3)
                    .then((value) {
                  _controller.fetchGetAll();
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                });
              },
              child: Text(S.of(context).save),
            ),
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(List<Product> product) {
    dataGridRows = product
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'id', value: _products.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<Icon>(columnName: 'edit', value: Icon(Icons.edit)),
              DataGridCell<Icon>(
                  columnName: 'delete', value: Icon(Icons.delete)),
            ]))
        .toList();
  }

  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(row.getCells()[1].value.toString()),
      ),
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: row.getCells()[2].value),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: row.getCells()[3].value,
      ),
    ]);
  }
}
