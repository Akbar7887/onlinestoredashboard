import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import 'package:onlinestoredashboard/models/catalogs/ProductImage.dart';
import 'package:onlinestoredashboard/models/constants/main_constant.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../generated/l10n.dart';
import '../../../models/UiO.dart';
import '../../../models/catalogs/Characteristic.dart';

final Controller _controller = Get.put(Controller());

TextEditingController _namecontrollerd = TextEditingController();
TextEditingController _valuenamecontrollerd = TextEditingController();

final _keyForm = GlobalKey<FormState>();

class AddcharacteristicDialog extends StatelessWidget {
  const AddcharacteristicDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CharacteristicDataGridSource _characteristicDataGridSource =
          CharacteristicDataGridSource(
              characteristics: _controller.characteristics);

      return SafeArea(
          child: Form(
              key: _keyForm,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 30,
                        child: Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).error;
                                }
                              },
                              decoration: MainConstant.decoration(
                                  S.of(context).characteristic),
                              textAlignVertical: TextAlignVertical.center,
                              controller: _namecontrollerd,
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).error;
                                }
                              },
                              decoration: MainConstant.decoration(
                                  S.of(context).valuename),
                              textAlignVertical: TextAlignVertical.center,
                              controller: _valuenamecontrollerd,
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (!_keyForm.currentState!.validate()) {
                                        return;
                                      }

                                      _controller.characteristic.value =
                                          Characteristic(
                                              id: _controller
                                                  .characteristic.value.id,
                                              name: _namecontrollerd.text,
                                              valuename:
                                                  _valuenamecontrollerd.text,
                                              product:
                                                  _controller.product.value);

                                      _controller
                                          .save("doc/characteristic/save",
                                              _controller.characteristic.value)
                                          .then((value) {
                                        _namecontrollerd.clear();
                                        _valuenamecontrollerd.clear();
                                        // Characteristic characteristic  =Characteristic.fromJson(value);

                                        _controller
                                            .getCharasteristic(
                                                "doc/characteristic/get",
                                                _controller.product.value.id
                                                    .toString())
                                            .then((value) {
                                          _controller.characteristics.value =
                                              value
                                                  .map((e) =>
                                                      Characteristic.fromJson(
                                                          e))
                                                  .toList();
                                        });
                                        _controller.characteristic =
                                            Characteristic().obs;
                                      });
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.grey[800])),
                                    child: Text("Добавить"))),

                            // Expanded(
                            //     child: FittedBox(
                            //         fit: BoxFit.contain,
                            //         child:
                            //             Text(_controller.product.value.name!)))
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
                          onCellTap: (cell) {
                            _controller.characteristic.value =
                                _controller.characteristics[
                                    cell.rowColumnIndex.rowIndex - 1];
                            _namecontrollerd.text =
                                _controller.characteristic.value.name!;
                            _valuenamecontrollerd.text =
                                _controller.characteristic.value.valuename!;
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
                  ]))));
    });
  }
}

class CharacteristicDataGridSource extends DataGridSource {
  CharacteristicDataGridSource(
      {required List<Characteristic> characteristics}) {
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
        child: Text(row.getCells()[1].value),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(row.getCells()[2].value),
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
