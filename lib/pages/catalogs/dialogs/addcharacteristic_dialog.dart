import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../generated/l10n.dart';
import '../../../models/UiO.dart';
import '../../../models/catalogs/Characteristic.dart';

final Controller _controller = Get.put(Controller());

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
              characteristics: _controller.characteristics, emptycount: 0);

      return SafeArea(
          child: Form(
              key: _keyForm,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(children: [
                    Container(
                        height: 30,
                        child: Row(
                          children: [
                            Container(
                                alignment: Alignment.topLeft,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _controller.characteristics.value.add(
                                          Characteristic(
                                              name: "", valuename: ""));
                                      // setState(() {
                                      _characteristicDataGridSource =
                                          CharacteristicDataGridSource(
                                              characteristics:
                                                  _controller.characteristics,
                                              emptycount: 1);
                                      // });
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
                                    child:
                                        Text(_controller.product.value.name!)))
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
                    )),
                    Container(
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                if (!_keyForm.currentState!.validate()) {
                                  return;
                                }

                                _controller.characteristics.value
                                    .forEach((element) {
                                  element.name = _namecontroller[_controller
                                          .characteristics.value
                                          .indexOf(element)]
                                      .text;
                                  element.valuename = _valuenamecontroller[
                                          _controller.characteristics.value
                                              .indexOf(element)]
                                      .text;
                                  element.product = _controller.product.value;
                                  element.productId =
                                      _controller.product.value.id;
                                });

                                _controller
                                    .savelist("doc/characteristic/save",
                                        _controller.characteristics.value)
                                    .then((value) {
                                  _controller.characteristics.value = value
                                      .map((e) => Characteristic.fromJson(e))
                                      .toList();
                                  Navigator.of(context)
                                      .pop(); // Dismiss alert dialog
                                });
                              },
                              child: Text(S.of(context).save)),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Dismiss alert dialog
                            },
                            child: Text(S.of(context).cancel),
                          )
                        ],
                      ),
                    )
                  ]))));
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
                  value: _controller.characteristics.value.indexOf(e) + 1),
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
            if (_controller.characteristics[dataGridRows.indexOf(row)].id ==
                null) {
              _controller.characteristics.removeAt(dataGridRows.indexOf(row));
            }
            _controller
                .deleteById(
                    "doc/characteristic/removecharacter",
                    _controller.characteristics[dataGridRows.indexOf(row)].id
                        .toString())
                .then((value) {
              _controller.characteristics.removeAt(dataGridRows.indexOf(row));
            });
          },
        ),
      ),
    ]);
  }
}
