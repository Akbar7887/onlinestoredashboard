import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:onlinestoredashboard/controller/ExchangeController.dart';
import 'package:onlinestoredashboard/models/calculate/Exchange.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../generated/l10n.dart';
import '../../models/UiO.dart';
import '../../widgets/onlineAppBar.dart';

final ExchangeController _exchangeController = Get.put(ExchangeController());
late ExchangeDataGridSource _exchangeDataGridSource;
var formatter = new DateFormat('yyyy-MM-dd');

class ExchangePage extends StatelessWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _exchangeDataGridSource = ExchangeDataGridSource(
          exchanges: _exchangeController.exchanges.value);

      return Scaffold(
          appBar: OnlineAppBar(), // extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    S.of(context).exchange,
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
                    child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: Colors.grey[700],
                    rowHoverColor: Colors.grey,
                    gridLineStrokeWidth: 1,
                    rowHoverTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  child: SfDataGrid(
                      source: _exchangeDataGridSource,
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
                          columnName: 'date',
                          // width: MediaQuery.of(context).size.width/2,
                          label: Center(
                            child: Text(
                              S.of(context).date,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                            columnName: "rates",
                            // maximumWidth: 150,
                            label: Container(
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.center,
                                child: Text(
                                  S.of(context).rate,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: "ratevalue",
                            //
                            label: Container(
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.center,
                                child: Text(
                                  S.of(context).valuerate,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                          columnName: "delete",
                          maximumWidth: 100,
                          label: Text(S.of(context).delete),
                        )
                      ]),
                ))
              ]),
            ),
            // drawer: DskNavigationDrawer(),

            // drawer: DskNavigationDrawer(),
          ));
    });
  }
}

class ExchangeDataGridSource extends DataGridSource {
  ExchangeDataGridSource({required List<Exchange> exchanges}) {
    dataGridRows = exchanges
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'id',
                  value: _exchangeController.exchanges.value.indexOf(e) + 1),
              DataGridCell<String>(
                  columnName: "date",
                  value: formatter.format(DateTime.parse(e.date!))),
              DataGridCell<String>(columnName: 'rates', value: e.rates),
              DataGridCell<double>(columnName: 'ratevalue', value: e.ratevalue),
              DataGridCell<Icon>(
                  columnName: 'delete',
                  value: Icon(
                    Icons.delete,
                    size: 15,
                  )),
            ]))
        .toList();
  }

  void addController(DataGridRow row) {}

  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((e) {
      switch (e.columnName) {
        case "delete":
          {
            return Container(
              child: e.value,
            );
            break;
          }
        case "date":
          {
            return Container(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      e.value.toString(),
                    )));
            break;
          }
        default:
          {
            return Container(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      e.value.toString(),
                    )));
            break;
          }
      }
    }).toList());
  }
}
