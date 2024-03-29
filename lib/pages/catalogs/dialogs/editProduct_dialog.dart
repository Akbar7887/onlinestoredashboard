import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import 'package:onlinestoredashboard/pages/catalogs/dialogs/addcharacteristic_dialog.dart';
import 'package:onlinestoredashboard/pages/catalogs/dialogs/productImage_part.dart';

import '../../../generated/l10n.dart';
import '../../../models/UiO.dart';
import '../../../models/calculate/Price.dart';
import '../../../models/catalogs/Catalog.dart';
import '../../../models/catalogs/Product.dart';
import '../../../models/constants/main_constant.dart';
import '../../calculate/exchange_page.dart';

TextEditingController _nameController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();
TextEditingController _dateController = TextEditingController();
TextEditingController _ratesController = TextEditingController();
TextEditingController _priceController = TextEditingController();
TextEditingController _pricesumController = TextEditingController();
TextEditingController _codeController = TextEditingController();
String _id = '';
final _keyEdit = GlobalKey<FormState>();
final _keyPrice = GlobalKey<FormState>();
final Controller _controller = Get.find();
Catalog? dropDown;

var _formatter = new DateFormat('yyyy-MM-dd');
var _formatterToSend = new DateFormat('yyyy-MM-ddTHH:mm:ss');

class EditProductDialog extends StatelessWidget {
  EditProductDialog({Key? key}) : super(key: key);

  Widget mainTab(BuildContext context) {
    if (_controller.catalog.value.id != null) {
      dropDown = _controller.catalogslist
          .firstWhere((element) => element.id == _controller.catalog.value.id);
    }
    return StatefulBuilder(
        builder: (BuildContext context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: DropdownButton<Catalog>(
                      hint: Text(S.of(context).catalog),
                      isExpanded: true,
                      items: _controller.catalogslist.value
                          .map<DropdownMenuItem<Catalog>>((e) {
                        return DropdownMenuItem(
                          child: Text(e.catalogname!),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropDown = value;
                          _controller.catalog.value = value!;
                        });
                      },
                      value: dropDown,
                    )),
                Container(
                    alignment: Alignment.topLeft, child: Text('№ ${_id}')),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                        controller: _codeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).validate;
                          }
                        },
                        style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            color: Colors.black),
                        decoration: MainConstant.decoration(
                            S.of(context).code))),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).validate;
                          }
                        },
                        style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            color: Colors.black),
                        decoration:
                            MainConstant.decoration(S.of(context).name))),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                        controller: _descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).validate;
                          }
                        },
                        style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            color: Colors.black),
                        decoration: MainConstant.decoration(
                            S.of(context).description))),
              ],
            ));
  }

  Widget priceTab(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 50, right: 50),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () async {
                      _controller.price = Price().obs;

                      await showdialogPrice(context);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[800])),
                    child: Text(S.of(context).add))),
            Expanded(
                child: ListView.builder(
                    itemCount: _controller.prices.value.length,
                    itemBuilder: (context, idx) {
                      return InkWell(
                          onTap: () {
                            _controller.price.value =
                                _controller.prices.value[idx];
                            MainConstant.getRate(DateTime.parse(
                                _controller.prices.value[idx].date!));
                            Future.delayed(const Duration(seconds: 0),
                                () => showdialogPrice(context));
                          },
                          child: Container(
                              // width: MediaQuery.of(context).size.width/8,
                              height: 50,
                              child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.black26),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                                // style: TextStyle(fontSize: 20),
                                                _formatter
                                                    .format(DateTime.parse(
                                              _controller
                                                  .prices.value[idx].date!,
                                            )))),
                                        VerticalDivider(),
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              _controller
                                                  .prices.value[idx].rates!,
                                              // style: TextStyle(fontSize: 20),
                                            )),
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              _controller
                                                  .prices.value[idx].price
                                                  .toString(),
                                            )),
                                        VerticalDivider(),
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              S.of(context).sum,
                                            )),
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              _controller
                                                  .prices.value[idx].pricesum
                                                  .toString(),
                                            )),
                                        Spacer(),
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            child: IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                _controller.deleteById(
                                                    "doc/price/delete",
                                                    _controller
                                                        .prices.value[idx].id
                                                        .toString());
                                              },
                                            )),
                                      ],
                                    ),
                                  ))));
                    })),
          ],
        ));
  }

  Future<void> showdialogPrice(BuildContext dialogcontext) async {
    if (_controller.price.value.date != null) {
      _dateController.text =
          _formatter.format(DateTime.parse(_controller.price.value.date!));
      _ratesController.text = _controller.price.value.rates!;
      _priceController.text = _controller.price.value.price.toString();
      _pricesumController.text = _controller.price.value.pricesum.toString();
    } else {
      _dateController.text = _formatter.format(DateTime.now());
      _ratesController.text = RATE.USD.name;
      _priceController.clear();
      _pricesumController.clear();
    }

    await showDialog<void>(
      context: dialogcontext,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(dialogcontext).form_dialog),
          // titlePadding: EdgeInsetsGeometry(),
          content: Container(
              height: MediaQuery.of(dialogContext).size.height / 2,
              width: MediaQuery.of(dialogContext).size.width / 2,
              child: Obx(() => SafeArea(
                  child: Form(
                      key: _keyPrice,
                      child: Column(
                        children: [
                          Container(
                              child: Row(
                            children: [
                              Expanded(
                                  // padding: EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(dialogContext).validate;
                                  }
                                },
                                keyboardType: TextInputType.datetime,
                                controller: _dateController,
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black),
                                decoration: MainConstant.decoration(
                                    S.of(dialogcontext).date),
                                onTap: () async {
                                  await showDatePicker(
                                    context: dialogcontext,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015),
                                    lastDate: DateTime(2030),
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      _dateController.text =
                                          _formatter.format(selectedDate);
                                      MainConstant.getRate(selectedDate);
                                    }
                                  });
                                  FocusScope.of(dialogContext)
                                      .requestFocus(new FocusNode());
                                },
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  '${S.of(dialogcontext).doll} ${_controller.rate.value.toString()} ${S.of(dialogcontext).sum}',
                                  style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              // padding: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return S.of(dialogContext).validate;
                                    }
                                  },
                                  onChanged: (value) {
                                    _pricesumController.text =
                                        (double.parse(value) *
                                                _controller.rate.value)
                                            .toString();
                                  },
                                  onEditingComplete: () {},
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  // Only numbers can be entered

                                  controller: _priceController,
                                  style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black),
                                  decoration: MainConstant.decoration(
                                      '${S.of(dialogContext).priceUE} ${RATE.USD.name}'))),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              // padding: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return S.of(dialogContext).validate;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: _pricesumController,
                                  style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black),
                                  decoration: MainConstant.decoration(
                                      '${S.of(dialogContext).priceUE} ${RATE.UZS.name}'))),
                        ],
                      ))))),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(dialogcontext).save),
              onPressed: () {
                if (!_keyEdit.currentState!.validate()) {
                  return;
                }

                _controller.price.value.date = _formatterToSend
                    .format(DateTime.parse(_dateController.text));
                _controller.price.value.rates = _ratesController.text;
                _controller.price.value.price =
                    double.parse(_priceController.text);

                _controller.price.value.product = _controller.product.value;
                _controller.price.value.pricesum =
                    double.parse(_pricesumController.text);
                _controller
                    .save("doc/price/save", _controller.price.value)
                    .then((value) {
                  _controller.prices.value.add(Price.fromJson(value));
                  _controller.prices.refresh();
                  Navigator.of(dialogContext).pop();
                });
              },
            ),
            TextButton(
              child: Text(S.of(dialogContext).cancel),
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
      if (_controller.product.value.id != null) {
        _nameController.text = _controller.product.value.name!;
        _descriptionController.text = _controller.product.value.description!;
        _id = _controller.product.value.id.toString();
        _codeController.text = _controller.product.value.codeproduct!;
      } else {
        _id = '';
        _nameController.clear();
        _descriptionController.clear();
        _codeController.clear();
      }
      if (_controller.catalog.value.id != null) {
        _controller.catalog.value = _controller.catalogslist.value.firstWhere(
            (element) => element.id == _controller.catalog.value.id);
      }

      return AlertDialog(
        title: Text(S.of(context).form_dialog),
        content: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height,
                child: DefaultTabController(
                    length: 4,
                    child: Form(
                        key: _keyEdit,
                        child: Column(children: [
                          Container(
                              child: TabBar(
                            labelColor: Colors.red,
                            unselectedLabelColor: Colors.black,
                            labelStyle:
                                TextStyle(fontSize: 15, fontFamily: UiO.font),
                            indicatorColor: Colors.red,
                            isScrollable: false,
                            tabs: [
                              Tab(text: S.of(context).main),
                              Tab(text: S.of(context).price),
                              Tab(text: S.of(context).image_store),
                              Tab(text: S.of(context).characteristics),
                            ],
                          )),
                          Expanded(
                              child: TabBarView(children: [
                            mainTab(context),
                            priceTab(context),
                            ProductImagePart(),
                            AddcharacteristicDialog()
                          ]))
                        ]))))),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (!_keyEdit.currentState!.validate()) {
                return;
              }
              if (dropDown == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).validate)));
                return;
              }

              Product? _product;
              _product = _controller.product.value;
              if (_product.id == null) {
                _product = Product();
              }
              _product.name = _nameController.text;
              _product.description = _descriptionController.text;
              _product.catalog = dropDown;
              _product.codeproduct = _codeController.text;
              _controller.save("doc/product/save", _product).then((value) {
                _controller.product.value = Product.fromJson(value);

                Product? result = _controller.products.value.firstWhereOrNull(
                    (element) => element.id == _controller.product.value.id);
                if (result == null) {
                  _controller.products.value.add(_controller.product.value);
                }
                _controller.products.refresh();
                Navigator.of(context).pop();
              });
            },
            child: Text(S.of(context).save),
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
