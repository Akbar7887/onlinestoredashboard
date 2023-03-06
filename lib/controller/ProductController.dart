import 'package:get/get.dart';
import 'package:onlinestoredashboard/controller/CatalogController.dart';

import '../models/catalogs/Product.dart';
import 'ApiConnector.dart';

class ProductController extends GetxController {
  final api = ApiConnector();
  final CatalogController _catalogController = Get.put(CatalogController());

  var products = <Product>[].obs;
  Rx<Product> product = Product().obs;

  @override
  void onInit() {
    fetchgetAll(
        "doc/product/get", _catalogController.catalog.value.id.toString());
    super.onInit();
  }

  fetchgetAll(String url, String id) async {
    final json = await api.getByParentId(url, id);
    this.products.value = json.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> save(String url, Product product) async {
    final json = await api.save(url, product);
    return Product.fromJson(json);
  }
}
