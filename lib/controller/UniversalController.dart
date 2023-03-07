import 'package:get/get.dart';
import 'package:onlinestoredashboard/controller/ApiConnector.dart';
import 'package:onlinestoredashboard/models/calculate/Price.dart';

class UniversalController extends GetxController {
  final api = ApiConnector();

  var prices = <Price>[].obs;
  var price = Price().obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<dynamic>> getByParentId(String url, String id) async {
    return await api.getByParentId(url, id);
  }


}
