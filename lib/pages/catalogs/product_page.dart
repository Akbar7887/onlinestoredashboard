import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import 'package:onlinestoredashboard/models/UiO.dart';
import 'package:onlinestoredashboard/models/catalogs/Catalog.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../generated/l10n.dart';
import '../../models/calculate/Price.dart';
import '../../models/catalogs/Characteristic.dart';
import '../../models/catalogs/ProductImage.dart';
import '../../models/constants/main_constant.dart';
import 'dialogs/addcharacteristic_dialog.dart';
import 'dialogs/delete_dialog.dart';
import 'dialogs/editProduct_dialog.dart';

final Controller _controller = Get.put(Controller());

late ProductDataGridSource _productDataGridSource;
// final _keyForm = GlobalKey<FormState>();
Catalog? dropDownValue;

class ProductPage extends GetView<Controller> {
  ProductPage() : super();

  Widget table(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    child: Row(
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                            onPressed: () {
                              // if (_controller.catalog.value.id == null) {
                              _controller.product.value = Product();
                              // }

                              _controller.productImages = <ProductImage>[].obs;
                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return EditProductDialog();
                                      }));
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.grey[800])),
                            child: Text(S.of(context).add))),
                    SizedBox(
                      width: 100,
                    ),
                    Expanded(
                        child: DropdownButtonFormField<Catalog>(
                            hint: Text(S.of(context).catalog),
                            isExpanded: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            items: _controller.catalogslist.value
                                .map((e) => DropdownMenuItem(
                                      child: Text(e.catalogname!),
                                      value: e,
                                    ))
                                .toList(),
                            value: dropDownValue,
                            onChanged: (value) {
                              dropDownValue = value!;
                              _controller
                                  .fetchgetAll(value.id.toString())
                                  .then((value) {
                                _controller.products.value = value;
                               //  _controller.products.refresh();
                                _productDataGridSource = ProductDataGridSource(
                                    _controller.products.value);
                              });
                            }))
                  ],
                )),
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
                      onCellDoubleTap: ((cell) {
                        // print(cell.rowColumnIndex.columnIndex);

                        _controller.product.value = _controller
                            .products.value[cell.rowColumnIndex.rowIndex - 1];
                        _controller.catalog.value =
                            _controller.product.value.catalog!;
                        _controller
                            .getByParentId("doc/productimage/v1/get",
                                _controller.product.value.id.toString())
                            .then((value) {
                          // if (value.isNotEmpty) {
                          _controller.productImages.value = value
                              .map((e) => ProductImage.fromJson(e))
                              .toList();
                          if (_controller.productImages.isNotEmpty) {
                            _controller.productImage.value =
                                _controller.productImages.value[0];
                          }
                          // } else {}
                        });
                        _controller
                            .getByParentId("doc/price/v1/get",
                                _controller.product.value.id.toString())
                            .then((value) {
                          _controller.prices.value =
                              value.map((e) => Price.fromJson(e)).toList();
                        });
                        _controller
                            .getCharasteristic("doc/characteristic/v1/get",
                                _controller.product.value.id.toString())
                            .then((value) {
                          _controller.characteristics.value = value
                              .map((e) => Characteristic.fromJson(e))
                              .toList();
                        });

                        Future.delayed(
                            const Duration(seconds: 0),
                            () => showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return EditProductDialog();
                                }));
                      }),
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
                          columnName: 'codeproduct',
                          // width: MediaQuery.of(context).size.width/2,
                          label: Center(
                            child: Text(
                              S.of(context).code,
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
                                child: Text(
                                  S.of(context).delete,
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

  deleteDialog(BuildContext context, int index) {}

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MainConstant.getRate(DateTime.now());
      _productDataGridSource =
          ProductDataGridSource(_controller.products.value);
      return SafeArea(
        child: Column(children: [
          Expanded(flex: 3, child: table(context)),
        ]),

        // drawer: DskNavigationDrawer(),

        // drawer: DskNavigationDrawer(),
      );
    });
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(List<Product> products) {
    dataGridRows = products
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'id',
                  value: _controller.products.value.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'codeproduct', value: e.codeproduct),
              DataGridCell<IconButton>(
                columnName: 'delete',
                value: IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 15,
                  ),
                  onPressed: () {
                    _controller.product.value =
                        _controller.products.value[products.indexOf(e)];
                    _controller
                        .deleteActive("doc/product/delete",
                            _controller.products.value[products.indexOf(e)].id!)
                        .then((value) {
                          _controller.products.value.remove(_controller.products.value[products.indexOf(e)]);
                      // _controller
                      //     .fetchgetAll(_controller.catalog.value.id.toString());
                      _controller.products.refresh();
                    });
                  },
                ),
              ),
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
            .map((e) => e.columnName != "delete"
                ? Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(e.value.toString()))
                : Container(
                    child: e.value,
                  ))
            .toList());
  }
}
