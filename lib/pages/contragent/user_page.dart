import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import '../../models/contragent/User.dart';
import 'dialogs/delete_user_dialog.dart';
import 'dialogs/editUser_dialog.dart';

final Controller _controller = Get.put(Controller());

late UserDataGridSource _userDataGridSource;

var _formatterToSend = new DateFormat('yyyy-MM-dd  HH:mm:ss');

class UserPage extends GetView<Controller> {
  UserPage() : super();

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
                              _controller.user.value = User();
                              // }

                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return EditUserDialog();
                                      }));
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.grey[800])),
                            child: Text(S.of(context).add))),
                    SizedBox(
                      width: 100,
                    ),
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
                      source: _userDataGridSource,
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
                        _controller.user.value = _controller
                            .users.value[cell.rowColumnIndex.rowIndex - 1];
                        // _controller
                        //     .getByParentId("doc/price/get",
                        //     _controller.product.value.id.toString())
                        //     .then((value) {
                        //   _controller.prices.value =
                        //       value.map((e) => Price.fromJson(e)).toList();
                        // });
                        // _controller
                        //     .getCharasteristic("doc/characteristic/get",
                        //     _controller.product.value.id.toString())
                        //     .then((value) {
                        //   _controller.characteristics.value = value
                        //       .map((e) => Characteristic.fromJson(e))
                        //       .toList();
                        // });

                        Future.delayed(
                            const Duration(seconds: 0),
                            () => showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return EditUserDialog();
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
                          columnName: 'user',
                          // width: MediaQuery.of(context).size.width/2,
                          label: Center(
                            child: Text(
                              S.of(context).user,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'phone',
                          // width: MediaQuery.of(context).size.width/2,
                          label: Center(
                            child: Text(
                              S.of(context).phone,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'date_create',
                          // width: MediaQuery.of(context).size.width/2,
                          label: Center(
                            child: Text(
                              S.of(context).date_create,
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
      _userDataGridSource = UserDataGridSource(_controller.users.value);
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

class UserDataGridSource extends DataGridSource {
  UserDataGridSource(List<User> users) {
    _controller.dataGridRows.value = users
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'id',
                  value: _controller.users.value.indexOf(e) + 1),
              DataGridCell<String>(columnName: 'user', value: e.username),
              DataGridCell<String>(columnName: 'phone', value: e.phone),
              DataGridCell<String>(
                  columnName: 'date_create',
                  value: _formatterToSend
                      .format(DateTime.parse(e.dateCreate.toString()))),
              DataGridCell<Icon>(
                  columnName: 'delete', value: Icon(Icons.delete)),
            ]))
        .toList();
  }

  // late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => _controller.dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row
            .getCells()
            .map((e) => e.columnName == 'delete'
                ? StatefulBuilder(
                    builder: (BuildContext context, idx) => Container(
                          alignment: Alignment.center,
                          // padding: EdgeInsets.symmetric(horizontal: 16),
                          child: InkWell(
                            child: row.getCells()[4].value,
                            onTap: () {
                              _controller
                                  .deleteById(
                                      "doc/user/delete",
                                      _controller
                                          .users[_controller.dataGridRows
                                              .indexOf(row)]
                                          .id
                                          .toString())
                                  .then((value) {
                                _controller.users.removeAt(
                                    _controller.dataGridRows.indexOf(row));
                              });
                            },
                          ),
                          // PopupMenuButton(
                          //   // tooltip: "Изменение строки",
                          //   itemBuilder: (BuildContext context) => [
                          //     PopupMenuItem(
                          //       onTap: () {
                          //         _controller.user.value = _controller
                          //             .users.value[dataGridRows.indexOf(row)];
                          //         Future.delayed(
                          //             const Duration(seconds: 0),
                          //                 () => showDialog(
                          //                 context: context,
                          //                 barrierDismissible: true,
                          //                 builder: (BuildContext dialogContext) {
                          //                   return DeleteUserDialog(
                          //                     url: "doc/user",
                          //                     index: dataGridRows.indexOf(row),
                          //                   );
                          //                 }));
                          //       },
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Text(S.of(context).delete),
                          //           SizedBox(
                          //             width: 5,
                          //           ),
                          //           Icon(
                          //             Icons.delete,
                          //             size: 20,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // )
                        ))
                : Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(e.value.toString())))
            .toList());
  }
}
