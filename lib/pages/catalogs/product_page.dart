import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:onlinestoredashboard/controller/CatalogController.dart';
import 'package:onlinestoredashboard/controller/ProductController.dart';
import 'package:onlinestoredashboard/models/UiO.dart';
import 'package:onlinestoredashboard/models/catalogs/Catalog.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';
import 'package:onlinestoredashboard/widgets/onlineAppBar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../generated/l10n.dart';
import '../../models/constants/main_constant.dart';
import 'dialogs/addcharacteristic_dialog.dart';
import 'dialogs/delete_dialog.dart';
import 'dialogs/editProduct_dialog.dart';

final CatalogController _catalogController = Get.put(CatalogController());
final ProductController _productController = Get.put(ProductController());

late ProductDataGridSource _productDataGridSource;
// final _keyForm = GlobalKey<FormState>();
// Catalog? dropDownValue;

class ProductPage extends GetView<CatalogController> {
  ProductPage() : super();

  Widget tree(BuildContext context, List<Catalog> catalogs) {
    return Container(
        child: Card(
            child: Column(
      children: [
        SizedBox(
          height: 20,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              S.of(context).catalog,
            ),
          ),
        ),
        Divider(),
        Expanded(child: SingleChildScrollView(child: TreeView(nodes: treeList(context, catalogs))))
      ],
    )));
  }

  List<TreeNode> treeList(BuildContext context, List<Catalog> list) {
    return list
        .map((e) => TreeNode(
            content: InkWell(
                onTap: () {
                  _catalogController.catalog.value = e;
                  _productController.fetchgetAll(e.id.toString()).then((value) {
                    _productDataGridSource = ProductDataGridSource(
                        _productController.products.value);
                  });
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
                            Flexible(
                              flex: 6,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        e.catalogname!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),

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
                          if (_catalogController.catalog.value.id == null) {
                            return;
                          }
                          _productController.product.value.id = null;
                          Future.delayed(
                              const Duration(seconds: 0),
                              () => showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return EditProductDialog();
                                  }));
                          // .then((value) {
                          // _controller.fetchGetAll().then((value) {
                          //  setState(() {
                          //    _productDataGridSource =
                          //        ProductDataGridSource(
                          //            _controller.productlist.value);
                          //  // });
                          // });
                          // });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[800])),
                        child: Text(S.of(context).add))),
                SizedBox(
                  height: 20,
                ),
                Expanded(
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
                      isScrollbarAlwaysShown: true,
                      // allowFiltering: true,
                      allowSorting: true,
                      allowEditing: true,
                      gridLinesVisibility: GridLinesVisibility.both,
                      onQueryRowHeight: (details) {
                        return UiO.datagrig_height;
                      },
                      headerRowHeight: UiO.datagrig_height,
                      onCellTap: (cell) {},
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
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.center,
                                child: Text(
                                  S.of(context).edit,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))),
                      ]),
                ))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MainConstant.getRate(DateTime.now());

      // _controller.getProducts(_controller.catalogs.value.first);
      _productDataGridSource =
          ProductDataGridSource(_productController.products.value);

      return Scaffold(
          appBar: OnlineAppBar(), // extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(children: [
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
                Expanded(
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.blue.shade800)),
                    child: Row(
                  children: [
                    Expanded(
                        child:
                            tree(context, _catalogController.catalogs.value)),
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

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(List<Product> products) {
    dataGridRows = products
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'id',
                  value: _productController.products.value.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<Icon>(
                  columnName: 'delete', value: Icon(Icons.more_vert_outlined)),
            ]))
        .toList();
  }

  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  // deleterow(BuildContext context, int index) async {
  //   return await
  // }

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
                      // tooltip: "Изменение строки",
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                            value: 0,
                            onTap: () async {
                              if (_catalogController.catalog.value.id == null) {
                                return;
                              }
                              _productController.product.value =
                                  _productController.products
                                      .value[dataGridRows.indexOf(row)];

                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return EditProductDialog();
                                      }));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).edit),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                              ],
                            )),
                        PopupMenuItem(
                          onTap: () {
                            _productController.product.value =
                                _productController
                                    .products.value[dataGridRows.indexOf(row)];
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AddcharacteristicDialog();
                                    }));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).characteristic),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.add_comment,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            _productController.product.value =
                                _productController.products
                                    .value[dataGridRows.indexOf(row)];
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext dialogContext) {
                                      return DeleteDialog(
                                        url: "doc/product/delete",
                                        index: dataGridRows.indexOf(row),
                                      );
                                    }));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).delete),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.delete,
                                size: 20,
                              ),
                            ],
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
