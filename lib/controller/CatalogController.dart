import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onlinestoredashboard/models/catalogs/Catalog.dart';
import 'package:onlinestoredashboard/models/catalogs/Characteristic.dart';
import 'package:onlinestoredashboard/models/catalogs/Product.dart';

import 'ApiConnector.dart';

class CatalogController extends GetxController {
  final api = ApiConnector();

  var _catalogs = <Catalog>[].obs;
  var _products = <Product>[].obs;
  var _catalogslist = <Catalog>[].obs;
  var _productlist = <Product>[].obs;
  Rx<Catalog> _catalog = Catalog().obs;
  var _characteristics = <Characteristic>[].obs;
  Rx<Product> _product = Product().obs;


  RxList<Catalog> get catalogs => _catalogs;
  RxList<Product> get products => _products;
  RxList<Catalog> get catalogslist => _catalogslist;
  RxList<Product> get productlist => _productlist;
  Rx<Catalog> get catalog => Catalog().obs;
  RxList<Characteristic> get characteristics => _characteristics;
  Rx<Product> get product => _product;


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

  Future<void> getCharasteristic(String url, String id) async {
    this.characteristics.value = [];
    final json = await api.getByParentId(url, id);
    this.characteristics.value =
        json.map((e) => Characteristic.fromJson(e)).toList();
    update();

  }

  creatCatalogList(List<Catalog> catalogs) {
    catalogs.forEach((element) {
      this.catalogslist.value.add(element);
      creatCatalogList(element.catalogs!);
      // update();
    });
  }

  getProducts(Catalog catalog) {
    this.productlist.value = catalog.products!;
    // update();
  }

  changeProducts(List<Product> products) {
    this.products.value = products;
    // update();
    // notifyChildrens();
  }

  addCatalog(Catalog catalog) {
    this.catalogs.add(catalog);
    // update();
    // notifyChildrens();
  }


  changeProduct(Product product)   {
    this.product.value = product;
    // update();
  }

   addCharacteristic(Characteristic characteristic)  {
    if(!this._characteristics.value.contains(characteristic)){
      this._characteristics.value.add(characteristic);
    }
    // update();
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
    catalog.value = Catalog.fromJson(json);
    return catalog.value!;
  }

  Future<bool> deleteById(url, id) async {
    return await api.deleteById(url, id);
  }

  Future<Catalog> saveProduct(String url, Product product, int id) async {
    final json = await api.savesub(url, product, id.toString());
    catalog.value = Catalog.fromJson(json);
    return catalog.value!;
  }
}
