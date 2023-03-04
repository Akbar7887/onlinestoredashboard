import 'package:get/get.dart';
import 'package:onlinestoredashboard/api/Api.dart';

class ApiConnector extends GetConnect{

  final api = Api();

  Future<dynamic> getfirst(String url) async {
    final json = await api.getfirst(url);

    return json;
  }
  Future<List<dynamic>> getAll(String url) async {
    final json = await api.getall(url);

    return json;
  }

  Future<dynamic> save(String url, Object object) async {
    return await api.post(url, object);
  }

  Future<dynamic> savesub(String url, Object object, String id) async {
    return await api.savesub(url, object, id);
  }

  Future<List<dynamic>> saveList(String url, String id, List<dynamic> list) async {
    return await api.saveList(url, id, list);
  }

  Future<bool> deleteById(String url, String id) async{
    return await api.delete(url, id);
  }

  Future<dynamic> deleteActive(String url, String id) async {
    return await api.deleteActive(url, id);
  }

  Future<dynamic> removethroughtParent(String url, String id) async {
    return await api.removethroughtParent(url, id);
  }

  Future<List<dynamic>> getByParentId(String url, String id ) async {
    final json = await api.getByParentId(url, id);
    return json;
  }
}