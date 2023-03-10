
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:onlinestoredashboard/controller/ApiConnector.dart';
import 'package:onlinestoredashboard/models/calculate/Price.dart';
import 'package:onlinestoredashboard/models/catalogs/ProductImage.dart';

class UniversalController extends GetxController {
  final api = ApiConnector();

  var prices = <Price>[].obs;
  Rx<Price> price = Price().obs;
  var rate = 0.0.obs;
  var productImages = <ProductImage>[].obs;

  @override
  void onInit() {
    super.onInit();
  }


  Future<List<dynamic>> getByParentId(String url, String id) async {
    return await api.getByParentId(url, id);
  }

  Future<dynamic> save(String url, dynamic object) async {

    return  await api.save(url, object);
  }

  Future<void> delete(String url, String id) async {

    await api.deleteById(url, id);
  }

  Future<dynamic> getRateFirst(String url, DateTime  dateTime) async {
    return  await api.getRateFirst(url, dateTime);
  }

  Future<dynamic> saveImage(
      String url, Uint8List data, Map<String, dynamic> param, String name) async {
    return await api.saveImage(url, data, param, name);
  }
}
