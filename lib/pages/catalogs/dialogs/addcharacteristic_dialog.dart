import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:onlinestoredashboard/controller/CharacteristicController.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controller/CatalogController.dart';
import '../../../controller/ProductController.dart';
import '../../../generated/l10n.dart';
import '../../../models/UiO.dart';
import '../../../models/catalogs/Characteristic.dart';

final CharacteristicController _characteristicController =
    Get.put(CharacteristicController());
final ProductController _productController = Get.put(ProductController());

List<TextEditingController> _namecontroller = [];
List<TextEditingController> _valuenamecontroller = [];
final _keyForm = GlobalKey<FormState>();

class AddcharacteristicDialog extends StatelessWidget {
  const AddcharacteristicDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CharacteristicDataGridSource _characteristicDataGridSource =
          CharacteristicDataGridSource(
              characteristics: _characteristicController.characteristics, emptycount: 0);

      return AlertDialog(
        title: Text(
            '${S.of(context).catalog_show_diagram} ${S.of(context).characteristics}'),
        content: SafeArea(
            child: Form(
                key: _keyForm,
                child:
                    StatefulBuilder(builder: (BuildContext context, setState) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Container(
                              height: 30,
                              child: Row(
                                children: [
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            _characteristicController.characteristics.value.add(
                                                Characteristic(
                                                    name: "", valuename: ""));
                                            setState(() {
                                              _characteristicDataGridSource =
                                                  CharacteristicDataGridSource(
                                                      characteristics:
                                                      _characteristicController
                                                              .characteristics,
                                                      emptycount: 1);
                                            });
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.grey[800])),
                                          child: Text("Добавить"))),
                                  SizedBox(width: 50),
                                  Expanded(
                                      child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                              _productController.product.value.name!)))
                                ],
                              )),
                          SizedBox(
                            height: 10,
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
                                source: _characteristicDataGridSource,
                                selectionMode: SelectionMode.single,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.vertical,
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
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'valuename',
                                    // width: MediaQuery.of(context).size.width/2,
                                    label: Center(
                                      child: Text(
                                        S.of(context).valuename,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                      columnName: "delete",
                                      label: Icon(Icons.more_vert_outlined)),
                                ]),
                          ))
                        ],
                      ));
                }))),
        actions: [
          TextButton(
            child: Text(S.of(context).save),
            onPressed: () {
              if (!_keyForm.currentState!.validate()) {
                return;
              }

              _characteristicController.characteristics.value.forEach((element) {
                element.name = _namecontroller[
                _characteristicController.characteristics.value.indexOf(element)]
                    .text;
                element.valuename = _valuenamecontroller[
                _characteristicController.characteristics.value.indexOf(element)]
                    .text;
              });

              _characteristicController
                  .savelist(
                      "doc/characteristic/addcharacterlist",
                  _productController.product.value.id.toString(),
                  _characteristicController.characteristics.value)
                  .then((value) {
                _characteristicController.characteristics.value = value;
                Navigator.of(context).pop(); // Dismiss alert dialog
              });
            },
          ),
          TextButton(
            child: Text(S.of(context).cancel),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss alert dialog
            },
          ),
        ],
      );
    });
  }
}

class CharacteristicDataGridSource extends DataGridSource {
  CharacteristicDataGridSource(
      {required List<Characteristic> characteristics,
      required int emptycount}) {
    // characteristics.sort((a, b) => a.id!.compareTo(b.id!));
    dataGridRows = characteristics
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'id',
                  value: _characteristicController.characteristics.value.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'valuename', value: e.valuename),
              DataGridCell<Icon>(
                  columnName: 'delete',
                  value: Icon(
                    Icons.delete,
                    size: 15,
                  )),
              // DataGridCell<bool>(columnName: 'editable', value: false),
            ]))
        .toList();
    // for (int i = 0; i < emptycount; i++) {
    //   dataGridRows.add(const DataGridRow(cells: [
    //     DataGridCell(columnName: 'id', value: ""),
    //     DataGridCell(columnName: 'name', value: ""),
    //     DataGridCell(columnName: 'valuename', value: ""),
    //     DataGridCell(
    //         columnName: 'delete',
    //         value: Icon(
    //           Icons.delete,
    //           size: 15,
    //         )),
    //   ]));
    // }
    _namecontroller = [];
    _valuenamecontroller = [];
    dataGridRows.forEach((element) {
      _namecontroller.add(
          TextEditingController(text: element.getCells()[1].value.toString()));
      _valuenamecontroller.add(
          TextEditingController(text: element.getCells()[2].value.toString()));
    });
  }

  void addController(DataGridRow row) {}

  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

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
        child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Ошибка";
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              // isDense: true,
            ),
            textAlignVertical: TextAlignVertical.center,
            controller: _namecontroller[dataGridRows.indexOf(row)]),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Ошибка";
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
            ),
            textAlignVertical: TextAlignVertical.center,
            controller: _valuenamecontroller[dataGridRows.indexOf(row)]),
      ),
      Container(
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          child: row.getCells()[3].value,
          onTap: () {
            if (_characteristicController.characteristics[dataGridRows.indexOf(row)].id ==
                null) {
              _characteristicController.characteristics.removeAt(dataGridRows.indexOf(row));
            }
            _characteristicController
                .deleteById(
                    "doc/characteristic/removecharacter",
                _characteristicController.characteristics[dataGridRows.indexOf(row)].id
                        .toString())
                .then((value) {
              _characteristicController.characteristics.removeAt(dataGridRows.indexOf(row));
            });
          },
        ),
      ),
    ]);
  }
}
