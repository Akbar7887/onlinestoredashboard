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

  @override
  void onInit() {
    login("Admin", "7887").then((value) {
      fetchGetAll();
      fetchAllExchange();
      fetchListOrganization();
      fetchAll("doc/user/get").then((value) {
        this.users.value = value.map((e) => User.fromJson(e)).toList();
      });
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
    final json = await api.getall("doc/exchange/get");
    this.exchanges.value = json.map((e) => Exchange.fromJson(e)).toList();
  }

  Future<void> fetchGetAll() async {
    final json = await api.getall("doc/catalog/get");
    this.catalogs.value = json.map((e) => Catalog.fromJson(e)).toList();

    this.catalogslist.value = <Catalog>[].obs;
    creatCatalogList(this.catalogs.value);
  }

  Future<List<Product>> fetchgetAll(String id) async {
    final json = await api.getByParentId("doc/product/get", id);
    return json.map((e) => Product.fromJson(e)).toList();
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

  Future<Catalog> savesub(String url, Catalog catalog, int id) async {
    final json = await api.savesub(url, catalog, id.toString());
    catalog = Catalog.fromJson(json);
    return catalog;
  }

  creatCatalogList(List<Catalog> catalogs) {
    catalogs.forEach((element) {
      this.catalogslist.value.add(element);
      creatCatalogList(element.catalogs!);
      // update();
    });
  }

  fetchListOrganization() async {
    final json = await api.getfirst("organization/get");
    Organization loadedorg = Organization.fromJson(json);

    if (loadedorg != null) {
      organization.value = loadedorg;
      // notifyChildrens();
    }
    update();
  }

  Future<dynamic?> changeObject(String url, dynamic object) async {
    dynamic result;
    final json = await api.save(url, object);
    if (object is Organization) {
      result = Organization.fromJson(json);
    }
    return result;
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
