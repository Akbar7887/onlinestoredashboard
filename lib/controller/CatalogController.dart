import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onlinestoredashboard/models/catalogs/Catalog.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';

import 'ApiConnector.dart';

class CatalogController extends GetxController {
  final api = ApiConnector();

  var catalogs = <Catalog>[].obs;
  List<Product> products = [];
  Catalog? catalog;

  @override
  void onInit() {
    fetchGetAll();
    super.onInit();
  }

  fetchGetAll() async {
    final json = await api.getAll("doc/catalog/get");
    catalogs.value = json.map((e) => Catalog.fromJson(e)).toList();
  }

  Future<Catalog> savesub(String url, Catalog catalog, int id) async {
    final json = await api.savesub(url, catalog, id.toString());
    catalog = Catalog.fromJson(json);
    return catalog;
  }
  Future<Catalog> deleteActive(String url, int id) async{
    final json = await api.deleteActive(url, id.toString());
    catalog = Catalog.fromJson(json);
    return catalog!;
  }

  Future<bool> deleteById(url, id) async {
    return await api.deleteById(url, id);
  }

  Future<Catalog> saveProduct(String url, Product product, int id) async {
    final json = await api.savesub(url, product, id.toString());
    catalog = Catalog.fromJson(json);
    return catalog!;
  }
}
