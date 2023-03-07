import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onlinestoredashboard/controller/ExchangeController.dart';
import 'package:onlinestoredashboard/models/calculate/Exchange.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../generated/l10n.dart';
import '../../models/UiO.dart';
import '../../models/constants/main_constant.dart';
import '../../widgets/onlineAppBar.dart';

enum RATE { USD, EUR, UZS }

final ExchangeController _exchangeController = Get.put(ExchangeController());
late ExchangeDataGridSource _exchangeDataGridSource;
var formatter = new DateFormat('yyyy-MM-dd');
TextEditingController _dateController = TextEditingController();
TextEditingController _ratesController = TextEditingController();
TextEditingController _valuerateController = TextEditingController();
final _keyFormEdit = GlobalKey<FormState>();

class ExchangePage extends StatelessWidget {
  const ExchangePage({Key? key}) : super(key: key);

  Future<void> showDialogForm(BuildContext context) async {
    if (_exchangeController.exchange.value.date != null) {
      _dateController.text = formatter
          .format(DateTime.parse(_exchangeController.exchange.value.date!));
      _ratesController.text = _exchangeController.exchange.value.rates!;
      _valuerateController.text =
          _exchangeController.exchange.value.ratevalue.toString();
    } else {
      _dateController.clear();
      _ratesController.text = RATE.USD.name;
      _valuerateController.clear();
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).form_dialog),
          content: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 2,
              child: Form(
                  key: _keyFormEdit,
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).validate;
                              }
                            },
                            keyboardType: TextInputType.datetime,

                            // O
                            controller: _dateController,
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                                color: Colors.black),
                            decoration:
                                MainConstant.decoration(S.of(context).date),
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2030),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  _dateController.text =
                                      formatter.format(selectedDate);
                                }
                              });
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                          )),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextFormField(
                              enabled: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).validate;
                                }
                              },
                              controller: _ratesController,
                              style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black),
                              decoration:
                                  MainConstant.decoration(S.of(context).rate))),
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).validate;
                                }
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              // Only numbers can be entered

                              controller: _valuerateController,
                              style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black),
                              decoration: MainConstant.decoration(
                                  S.of(context).valuerate))),
                    ],
                  ))),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).save),
              onPressed: () {
                if (!_keyFormEdit.currentState!.validate()) {
                  return;
                }

                _exchangeController.exchange.value.date =
                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                        .format(DateTime.parse(_dateController.text));
                _exchangeController.exchange.value.rates =
                    _ratesController.text;
                _exchangeController.exchange.value.ratevalue =
                    double.parse(_valuerateController.text);

                _exchangeController
                    .save(_exchangeController.exchange.value)
                    .then((value) {
                  _exchangeController.fetchAll();
                  Navigator.of(dialogContext).pop();
                });
              },
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _exchangeDataGridSource =
          ExchangeDataGridSource(_exchangeController.exchanges.value);

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
                Container(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                        onPressed: () {
                          _exchangeController.exchange = Exchange().obs;
                          Future.delayed(const Duration(seconds: 0),
                              () => showDialogForm(context));
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
                      onCellDoubleTap: (cell) {
                        _exchangeController.exchange.value = _exchangeController
                            .exchanges.value[cell.rowColumnIndex.rowIndex - 1];
                        Future.delayed(const Duration(seconds: 0),
                            () => showDialogForm(context));
                      },
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
                          label: Text(
                            S.of(context).delete,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
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
  ExchangeDataGridSource(List<Exchange> exchanges) {
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
              DataGridCell<IconButton>(
                  columnName: 'delete',
                  value: IconButton(
                    onPressed: () {
                      _exchangeController.delete(e.id.toString()).then((value) {
                        _exchangeController.fetchAll();
                      });
                    },
                    icon: Icon(Icons.delete, size: 15),
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
        case "id":
          {
            return Container(
                child: Center(
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
