import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onlinestoredashboard/controller/CatalogController.dart';
import 'package:onlinestoredashboard/models/catalogs/Characteristic.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../generated/l10n.dart';

final CatalogController _controller = Get.put(CatalogController());
List<TextEditingController> controllername = [];

class Addcharacteristic extends StatelessWidget {
  const Addcharacteristic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CharacteristicDataGridSource _characteristicDataGridSource =
          CharacteristicDataGridSource(_controller.characteristics.value);

      return _controller.characteristics.value.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AlertDialog(
              title: Text(
                  '${S.of(context).catalog_show_diagram} ${S.of(context).characteristics}'),
              content: SafeArea(
                  child: Form(
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
                                                        .characteristics.value);
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
                              source: _characteristicDataGridSource,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.fill,
                              editingGestureType: EditingGestureType.tap,
                              onCellTap: (cell) {
                                _controller
                                    .characteristics[
                                        cell.rowColumnIndex.rowIndex - 1]
                                    .editable = true;

                                if (cell.rowColumnIndex.rowIndex > -1) {
                                  if (cell.rowColumnIndex.columnIndex == 2) {}
                                  if (cell.rowColumnIndex.columnIndex == 3) {}
                                  if (cell.rowColumnIndex.columnIndex == 4) {}
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
                                  columnName: 'valuename',
                                  // width: MediaQuery.of(context).size.width/2,
                                  label: Center(
                                    child: Text(
                                      S.of(context).valuename,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                    columnName: "edit",
                                    maximumWidth: 120,
                                    label: Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          S.of(context).edit,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: "delete",
                                    maximumWidth: 100,
                                    label: Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          S.of(context).delete,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ))),
                              ]),
                        )
                      ],
                    )),
              ))),
              actions: [
                TextButton(
                  child: Text(S.of(context).save),
                  onPressed: () {
                    _characteristicDataGridSource.dataGridRows
                        .forEach((element) {
                      _controller
                          .characteristics
                          .value[_characteristicDataGridSource.dataGridRows
                              .indexOf(element)]
                          .name = element.getCells()[1].value;
                      _controller
                          .characteristics
                          .value[_characteristicDataGridSource.dataGridRows
                              .indexOf(element)]
                          .valuename = element.getCells()[2].value;
                    });
                    // Navigator.of(context).pop(); // Dismiss alert dialog
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
              DataGridCell<Icon>(columnName: 'edit', value: Icon(Icons.edit)),
              DataGridCell<Icon>(
                  columnName: 'delete', value: Icon(Icons.delete)),
              // DataGridCell<bool>(columnName: 'editable', value: false),
            ]))
        .toList();
  }

  //
  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;
  dynamic newCellValue;



  //
  // // @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    controllername
        .add(TextEditingController(text: row.getCells()[1].value.toString()));

    
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: TextField(controller: controllername[dataGridRows.indexOf(row)]),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(row.getCells()[2].value.toString()),
      ),
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: row.getCells()[3].value),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: row.getCells()[4].value,
      ),
    ]);
  }

// @override
// void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
//     GridColumn column) {}
//
// @override
// Widget buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
//     GridColumn column, CellSubmit submitCell) {
//   return Container();
// }
}
