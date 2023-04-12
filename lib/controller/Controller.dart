import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:onlinestoredashboard/controller/ApiConnector.dart';
import 'package:onlinestoredashboard/models/Organization.dart';
import 'package:onlinestoredashboard/models/contragent/User.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/calculate/Exchange.dart';
import '../models/calculate/Price.dart';
import '../models/catalogs/Catalog.dart';
import '../models/catalogs/Characteristic.dart';
import '../models/catalogs/Product.dart';
import '../models/catalogs/ProductImage.dart';

class Controller extends GetxController {
  final api = ApiConnector();
  var organization = Organization().obs;
  var zero = 0.obs;
  var catalogs = <Catalog>[].obs;
  var catalogslist = <Catalog>[].obs;
  Rx<Catalog> catalog = Catalog().obs;
  var characteristics = <Characteristic>[].obs;
  var characteristic = Characteristic().obs;
  var exchanges = <Exchange>[].obs;
  var exchange = Exchange().obs;
  var products = <Product>[].obs;
  Rx<Product> product = Product().obs;
  var page = 0.obs;
  var prices = <Price>[].obs;
  Rx<Price> price = Price().obs;
  var rate = 0.0.obs;
  var productImages = <ProductImage>[].obs;
  var productImage = ProductImage().obs;
  var users = <User>[].obs;
  Rx<User> user = User().obs;
  var dataGridRows = <DataGridRow>[].obs;
   // Rx<String> token = ''.obs;

  @override
  void onInit() {
    fetchListOrganization();
    fetchGetAll();
    fetchAllExchange();
    fetchAll("doc/user/get").then((value) {
      this.users.value = value.map((e) => User.fromJson(e)).toList();
    });

    super.onInit();
  }

  Future<bool> login(String username, String password) async {
    return await api.login(username, password);
  }

  Future<List<dynamic>> fetchAll(String url) async {
    return await api.getall(url);
  }

  Future<void> fetchAllExchange() async {
    await api.getall("doc/exchange/get").then((value) {
      this.exchanges.value = value.map((e) => Exchange.fromJson(e)).toList();
    });
  }

  Future<void> fetchGetAll() async {
    await api.getall("doc/catalog/get").then((value) {
      this.catalogs.value = value.map((e) => Catalog.fromJson(e)).toList();

      this.catalogslist.value = <Catalog>[].obs;
      creatCatalogList(this.catalogs.value);
    });
  }

  Future<List<Product>> fetchgetAll(String id) async {
    await api.getByParentId("doc/product/get", id).then((value) {
      return value.map((e) => Product.fromJson(e)).toList();
    });
    return [];
  }

  Future<dynamic> getRateFirst(String url, DateTime dateTime) async {
    return await api.getRatefirst(url, dateTime);
  }

  Future<List<dynamic>> getByParentId(String url, String id) async {
    return await api.getByParentId(url, id);
  }

  Future<dynamic> save(String url, dynamic object) async {
    return await api.save(url, object);
  }

  Future<Catalog?> savesub(String url, Catalog catalog, int id) async {
    await api.savesub(url, catalog, id.toString()).then((value) {
      catalog = Catalog.fromJson(value);
      return catalog;
    });
    return null;
  }

  creatCatalogList(List<Catalog> catalogs) {
    catalogs.forEach((element) {
      this.catalogslist.value.add(element);
      creatCatalogList(element.catalogs!);
      // update();
    });
  }

  fetchListOrganization() async {
    await api.getall("organization/get").then((value) {
      List<Organization> _listOrganization =
          value.map((e) => Organization.fromJson(e)).toList();
      if (_listOrganization.length != 0) {
        organization.value = _listOrganization.first;
      }
    });
  }

  Future<dynamic?> changeObject(String url, dynamic object) async {
    dynamic result;
    await api.save(url, object).then((value) {
      if (object is Organization) {
        result = Organization.fromJson(value);
      }
      return result;
    });
  }

  Future<bool> deleteById(url, id) async {
    return await api.deletebyId(url, id);
  }

  Future<bool> deleteActive(String url, int id) async {
    return await api.deleteActive(url, id.toString());
  }

  Future<dynamic> saveImage(String url, Uint8List data,
      Map<String, dynamic> param, String name) async {
    return await api.saveImage(url, data, param, name);
  }

  Future<List<dynamic>> getCharasteristic(String url, String id) async {
    return await api.getByParentId(url, id);
  }

  Future<dynamic> savelist(
    String url,
    List<Characteristic> list,
  ) async {
    return await api.saveList(url, list);
  }
}

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Controller());
  }
}
