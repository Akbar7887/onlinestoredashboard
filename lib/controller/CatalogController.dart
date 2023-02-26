import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onlinestoredashboard/models/catalogs/Catalog.dart';

import 'ApiConnector.dart';

class CatalogController extends GetxController {
  final api = ApiConnector();

  var catalogs = <Catalog>[].obs;
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
}
