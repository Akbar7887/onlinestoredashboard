import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onlinestoredashboard/controller/CatalogController.dart';
import 'package:onlinestoredashboard/models/catalogs/Characteristic.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../generated/l10n.dart';
import '../../models/UiO.dart';

final CatalogController _controller = Get.put(CatalogController());
List<TextEditingController> _namecontroller = [];
List<TextEditingController> _valuenamecontroller = [];
final _keyForm = GlobalKey<FormState>();

class Addcharacteristic extends StatelessWidget {
  const Addcharacteristic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CharacteristicDataGridSource _characteristicDataGridSource =
          CharacteristicDataGridSource(_controller.characteristics.value);

      return AlertDialog(
        title: Text(
            '${S.of(context).catalog_show_diagram} ${S.of(context).characteristics}'),
        content: SafeArea(
            child: Form(
                key: _keyForm,
                child: StatefulBuilder(
                  builder: (BuildContext context, setState) => Container(
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
                                            _controller.characteristics.value
                                                .add(Characteristic());
                                            setState(() {
                                              _characteristicDataGridSource =
                                                  CharacteristicDataGridSource(
                                                      _controller
                                                          .characteristics
                                                          .value);
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
                                              _controller.product.value.name!)))
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
                                      // maximumWidth: 100,

                                      label: Icon(
                                            Icons.more_vert_outlined
                                          )),
                                ]),
                          ))
                        ],
                      )),
                ))),
        actions: [
          TextButton(
            child: Text(S.of(context).save),
            onPressed: () {
              if (!_keyForm.currentState!.validate()) {
                return;
              }

              _controller.characteristics.value.forEach((element) {
                element.name = _namecontroller[
                        _controller.characteristics.value.indexOf(element)]
                    .text;
                element.valuename = _valuenamecontroller[
                        _controller.characteristics.value.indexOf(element)]
                    .text;
              });

              _controller
                  .savelist(
                      "doc/characteristic/addcharacterlist",
                      _controller.product.value.id.toString(),
                      _controller.characteristics.value)
                  .then((value) {
                _controller.characteristics.value = value!;
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
  CharacteristicDataGridSource(List<Characteristic> characteristics) {
    dataGridRows = characteristics
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'id',
                  value: _controller.characteristics.value.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'valuename', value: e.valuename),
              DataGridCell<Icon>(
                  columnName: 'delete', value: Icon(Icons.delete, size: 15,)),
              // DataGridCell<bool>(columnName: 'editable', value: false),
            ]))
        .toList();

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
  dynamic newCellValue;

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
        child: row.getCells()[3].value,
      ),
    ]);
  }

}
