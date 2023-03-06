import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/catalogs/Characteristic.dart';
import 'ApiConnector.dart';

class CharacteristicController extends GetxController {
  final api = ApiConnector();
  var characteristics = <Characteristic>[].obs;

  Future<void> getCharasteristic(String url, String id) async {
    this.characteristics.value = [];
    final json = await api.getByParentId(url, id);
    this.characteristics.value =
        json.map((e) => Characteristic.fromJson(e)).toList();
    update();
  }

  Future<List<Characteristic>> savelist(
    String url,
    String id,
    List<Characteristic> list,
  ) async {
    final json = await api.saveList(url, id.toString(), list);

    List<Characteristic> characteristics =
        json.map((e) => Characteristic.fromJson(e)).toList();

    // _list.sort((a, b) => a.id!.compareTo(b.id!));
    return characteristics;
  }

  Future<bool> deleteById(url, id) async {
    return await api.deleteById(url, id);
  }
}
