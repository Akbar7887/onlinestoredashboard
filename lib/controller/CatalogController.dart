import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onlinestoredashboard/models/catalogs/Catalog.dart';
import 'package:onlinestoredashboard/models/catalogs/Characteristic.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';

import 'ApiConnector.dart';

class CatalogController extends GetxController {
  final api = ApiConnector();

  var catalogs = <Catalog>[].obs;
  var products = <Product>[].obs;
  var catalogslist = <Catalog>[].obs;
  var productlist = <Product>[].obs;
  Catalog? catalog;
  var characteristics = <Characteristic>[].obs;
  Rx<Product> product = Product().obs;

  @override
  void onInit() {
    fetchGetAll();
    // getProducts(this.catalogs.value.first);
    super.onInit();
  }

  fetchGetAll() async {
    final json = await api.getAll("doc/catalog/get");
    this.catalogs.value = json.map((e) => Catalog.fromJson(e)).toList();

    this.catalogslist.value = <Catalog>[].obs;
    creatCatalogList(this.catalogs.value);
    update();
  }

  fetchGetAllCharacteristic(String url, String id) async {
    final json = await api.getByParentId(url, id);
    this.characteristics.value =
        json.map((e) => Characteristic.fromJson(e)).toList();
    update();
  }

  creatCatalogList(List<Catalog> catalogs) {
    catalogs.forEach((element) {
      this.catalogslist.value.add(element);
      creatCatalogList(element.catalogs!);
      update();
    });
  }

  getProducts(Catalog catalog) {
    this.productlist.value = catalog.products!;
    update();
  }

  changeProducts(List<Product> product) {
    this.products.value = product;
    update();
    // notifyChildrens();
  }

  addCatalog(Catalog catalog) {
    this.catalogs.add(catalog);
    update();
    // notifyChildrens();
  }

  changeProduct(Product product) {
    this.product.value = product;
    update();
  }

  Future<Catalog> savesub(String url, Catalog catalog, int id) async {
    final json = await api.savesub(url, catalog, id.toString());
    catalog = Catalog.fromJson(json);
    return catalog;
  }

  Future<List<Characteristic>?> savelist(
    String url,
    String id,
    List<Characteristic> list,
  ) async {
    final json = await api.saveList(url, id.toString(), list);

    Product product = Product.fromJson(json);

    // _list.sort((a, b) => a.id!.compareTo(b.id!));
    return product.characteristics;
  }

  Future<Catalog> deleteActive(String url, int id) async {
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
