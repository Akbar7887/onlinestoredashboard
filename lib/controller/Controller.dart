import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onlinestoredashboard/controller/ApiConnector.dart';
import 'package:onlinestoredashboard/models/Organization.dart';

class Controller extends GetxController {
  final api = ApiConnector();
  Organization? organization;
  var zero = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchListOrganization();
  }

  fetchListOrganization() async {
    final json = await api.getfirst("organization/get");
    Organization loadedorg = Organization.fromJson(json);

    if (loadedorg != null) {
      organization = loadedorg;
      // notifyChildrens();
    }
    update();
  }

  Future<dynamic?> changeObject(String url, dynamic object) async {
    dynamic result;
    final json = await api.save(url, object);
    if (object is Organization) {
      result = Organization.fromJson(json);
    }
    return result;
  }

  Future<bool> deleteById(url, id) async {
    return await api.deleteById(url, id);
  }

}

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Controller());
  }
}
