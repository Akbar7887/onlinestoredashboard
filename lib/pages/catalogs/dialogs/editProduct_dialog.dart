import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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

TextEditingController _nameController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();

String _id = '';
final _keyFormEdit = GlobalKey<FormState>();
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
    _universalController.getAll("doc/price/get").then((value) =>
        _universalController.prices.value =
            value.map((e) => Price.fromJson(e)).toList());
    return Container(
      child: ListView.builder(
          itemCount: _universalController.prices.value.length,
          itemBuilder: (context, idx) {
            return Container(
              decoration: BoxDecoration(color: Colors.black),
              height: 50,
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Card(
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                  style: TextStyle(fontSize: 20),
                                  _formatter.format(DateTime.parse(
                                    _universalController
                                        .prices.value[idx].date!,
                                  )))))),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Card(
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                _universalController.prices.value[idx].rates!,
                                style: TextStyle(fontSize: 20),
                              )))),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Card(
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                  _universalController.prices.value[idx].price
                                      .toString(),
                                  style: TextStyle(fontSize: 20))))),
                ],
              ),
            );
          }),
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
                        key: _keyFormEdit,
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
              if (!_keyFormEdit.currentState!.validate()) {
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
