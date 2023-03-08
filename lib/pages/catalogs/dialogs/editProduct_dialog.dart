import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onlinestoredashboard/controller/ProductController.dart';
import 'package:onlinestoredashboard/controller/UniversalController.dart';

import '../../../controller/CatalogController.dart';
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

String _id = '';
final _keyEdit = GlobalKey<FormState>();
final CatalogController _catalogController = Get.put(CatalogController());
final ProductController _productController = Get.put(ProductController());
final UniversalController _universalController = Get.put(UniversalController());

var _formatter = new DateFormat('yyyy-MM-dd');

class EditProductDialog extends StatelessWidget {
  EditProductDialog({Key? key}) : super(key: key);

  Widget mainTab(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: DropdownButton<Catalog>(
                      isExpanded: true,
                      items: _catalogController.catalogslist.value
                          .map<DropdownMenuItem<Catalog>>((e) {
                        return DropdownMenuItem(
                          child: Text(e.catalogname!),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(
                            () => _catalogController.catalog.value = value!);
                      },
                      value: _catalogController.catalog.value,
                    )),
                Container(
                    alignment: Alignment.topLeft, child: Text('№ ${_id}')),
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
    _universalController
        .getByParentId(
            "doc/price/get", _productController.product.value.id.toString())
        .then((value) => _universalController.prices.value =
            value.map((e) => Price.fromJson(e)).toList());
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
                       await showdialogPrice(context);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[800])),
                    child: Text(S.of(context).add))),
            Expanded(
                child: ListView.builder(
                    itemCount: _universalController.prices.value.length,
                    itemBuilder: (context, idx) {
                      return Container(
                          // width: MediaQuery.of(context).size.width/8,
                          height: 80,
                          child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        child: Card(
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                    // style: TextStyle(fontSize: 20),
                                                    _formatter
                                                        .format(DateTime.parse(
                                                  _universalController
                                                      .prices.value[idx].date!,
                                                )))))),
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        child: Card(
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  _universalController
                                                      .prices.value[idx].rates!,
                                                  // style: TextStyle(fontSize: 20),
                                                )))),
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        child: Card(
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  _universalController
                                                      .prices.value[idx].price
                                                      .toString(),
                                                )))),
                                  ],
                                ),
                              )));
                    })),
          ],
        ));
  }

  Future<void> showdialogPrice(BuildContext context) async {
    if (_universalController.price.value.date != null) {
      _dateController.text = _formatter
          .format(DateTime.parse(_universalController.price.value.date!));
      _ratesController.text = _universalController.price.value.rates!;
      _priceController.text = _universalController.price.value.toString();
    } else {
      _dateController.clear();
      _ratesController.text = RATE.USD.name;
      _priceController.clear();
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).form_dialog),
          // titlePadding: EdgeInsetsGeometry(),
          content: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 2,
              child: Form(
                  key: _keyEdit,
                  child: Column(
                    children: [
                      Container(
                          // width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).validate;
                              }
                            },
                            keyboardType: TextInputType.datetime,
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
                                      _formatter.format(selectedDate);
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
                              decoration: MainConstant.decoration(
                                  '${S.of(context).priceUE} ${_ratesController.text}'))),
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

                              controller: _priceController,
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
                if (!_keyEdit.currentState!.validate()) {
                  return;
                }

                // _exchangeController.exchange.value.date =
                //     DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                //         .format(DateTime.parse(_dateController.text));
                // _exchangeController.exchange.value.rates =
                //     _ratesController.text;
                // _exchangeController.exchange.value.ratevalue =
                //     double.parse(_valuerateController.text);
                //
                // _exchangeController
                //     .save(_exchangeController.exchange.value)
                //     .then((value) {
                //   _exchangeController.fetchAll();
                //   Navigator.of(dialogContext).pop();
                // });
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
      if (_productController.product.value.id != null) {
        _nameController.text = _productController.product.value.name!;
        _descriptionController.text =
            _productController.product.value.description!;
        _id = _productController.product.value.id.toString();
      } else {
        _id = '';
        _nameController.clear();
        _descriptionController.clear();
      }
      if (_catalogController.catalog.value.id != null) {
        _catalogController.catalog.value = _catalogController.catalogslist.value
            .firstWhere(
                (element) => element.id == _catalogController.catalog.value.id);
      }

      return AlertDialog(
        title: Text(S.of(context).form_dialog),
        content: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height,
                child: DefaultTabController(
                    length: 2,
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
                            ],
                          )),
                          Expanded(
                              child: TabBarView(children: [
                            mainTab(context),
                            priceTab(context)
                          ]))
                        ]))))),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (!_keyEdit.currentState!.validate()) {
                return;
              }
              Product? _product;
              _product = _productController.product.value;
              if (_product == null) {
                _product = Product();
              }
              _product.name = _nameController.text;
              _product.description = _descriptionController.text;

              _product.catalog = _catalogController.catalog.value;
              _productController
                  .save("doc/product/save", _product)
                  .then((value) {
                _productController.fetchgetAll(
                    _catalogController.catalog.value.id.toString());
                Navigator.of(context).pop(); // Dismiss alert dialog
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
