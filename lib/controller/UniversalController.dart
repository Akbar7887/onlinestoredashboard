
import 'package:get/get.dart';
import 'package:onlinestoredashboard/controller/ApiConnector.dart';
import 'package:onlinestoredashboard/models/calculate/Price.dart';

class UniversalController extends GetxController {
  final api = ApiConnector();

  var prices = <Price>[].obs;
  Rx<Price> price = Price().obs;
  var rate = 0.0.obs;

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
}
