import 'package:get/get.dart';
import 'package:onlinestoredashboard/models/calculate/Exchange.dart';

import 'ApiConnector.dart';

class ExchangeController extends GetxController {
  final api = ApiConnector();
  var exchanges = <Exchange>[].obs;
  var exchange = Exchange().obs;

  @override
  void onInit() {

    fetchAll();
    super.onInit();
  }

  Future<void> fetchAll() async {
    final json = await api.getAll("doc/exchange/get");
    this.exchanges.value = json.map((e) => Exchange.fromJson(e)).toList();
  }

  Future<Exchange> save(Exchange exchange) async {

    final json =  await api.save("doc/exchange/save", exchange);
    return Exchange.fromJson(json);
  }

  Future<void> delete(String id) async {

     await api.deleteById("/doc/exchange/delete", id);
  }
}
