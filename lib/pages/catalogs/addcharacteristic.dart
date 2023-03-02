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
                child: Container(
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
                                        onPressed: () {},
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
                              headerGridLinesVisibility:
                                  GridLinesVisibility.vertical,
                              columnWidthMode: ColumnWidthMode.fill,
                              // allowFiltering: true,
                              allowSorting: true,
                              allowEditing: true,
                              gridLinesVisibility: GridLinesVisibility.both,
                              onCellTap: (cell) {
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
                                    columnName: "delete",
                                    maximumWidth: 150,
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
              )),
              actions: [
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
                  columnName: 'delete', value: Icon(Icons.delete)),
            ]))
        .toList();
  }

  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row
            .getCells()
            .map((e) => (e.columnName == 'delete')
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: e.value)
                : Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(e.value.toString())))
            .toList());
  }
}
