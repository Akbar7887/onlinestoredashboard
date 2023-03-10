import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onlinestoredashboard/models/catalogs/Catalog.dart';
import 'package:onlinestoredashboard/models/catalogs/Characteristic.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';

import 'ApiConnector.dart';

class CatalogController extends GetxController {
  final api = ApiConnector();

  var catalogs = <Catalog>[].obs;
  var catalogslist = <Catalog>[].obs;
  Rx<Catalog> catalog = Catalog().obs;


  // RxList<Catalog> get catalogs => _catalogs;
  // RxList<Product> get products => _products;
  // RxList<Catalog> get catalogslist => _catalogslist;
  // RxList<Product> get productlist => _productlist;
  // Rx<Catalog> get catalog => Catalog().obs;
  // RxList<Characteristic> get characteristics => _characteristics;
  // Rx<Product>? get product => _product;
  //

  @override
  void onInit() {
    fetchGetAll();
    if(catalogs.value.length > 0){
      catalog.value = catalogs.first;
    }
    // getProducts(this.catalogs.value.first);
    super.onInit();
  }


  Future<void> fetchGetAll() async {
    final json = await api.getAll("doc/catalog/get");
    this.catalogs.value = json.map((e) => Catalog.fromJson(e)).toList();

    this.catalogslist.value = <Catalog>[].obs;
    creatCatalogList(this.catalogs.value);
    update();
  }

  creatCatalogList(List<Catalog> catalogs) {
    catalogs.forEach((element) {
      this.catalogslist.value.add(element);
      creatCatalogList(element.catalogs!);
      // update();
    });
  }




  // getProducts(Catalog catalog) {
  //   this.productlist.value = catalog.products!;
  //   // update();
  // }

  addCatalog(Catalog catalog) {
    this.catalogs.add(catalog);
    // update();
    // notifyChildrens();
  }

  Future<Catalog> save(String url, Catalog catalog) async {
    final json = await api.save(url, catalog);
    catalog = Catalog.fromJson(json);
    return catalog;
  }

  Future<Catalog> savesub(String url, Catalog catalog, int id) async {
    final json = await api.savesub(url, catalog, id.toString());
    catalog = Catalog.fromJson(json);
    return catalog;
  }

  Future<bool> deleteActive(String url, int id) async {
    return await api.deleteActive(url, id.toString());
  }

  Future<bool> deleteById(url, id) async {
    return await api.deleteById(url, id);
  }

  Future<dynamic> saveImage(
      String url, Uint8List data, Map<String, dynamic> param, String name) async {
    return await api.saveImage(url, data, param, name);
  }
  // Future<Catalog> saveProduct(String url, Product product, int id) async {
  //   final json = await api.savesub(url, product, id.toString());
  //   catalog.value = Catalog.fromJson(json);
  //   return catalog.value;
  // }

}
