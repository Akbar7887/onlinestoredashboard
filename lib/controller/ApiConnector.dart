import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:onlinestoredashboard/api/Api.dart';

class ApiConnector extends GetConnect{

  final api = Api();


  @override
  void onInit() {

    super.onInit();
  }

  Future<dynamic> getfirst(String url) async {
    final json = await api.getfirst(url);

    return json;
  }

  Future<dynamic> getRateFirst(String url, DateTime dateTime) async {
    return await api.getRatefirst(url, dateTime);
  }
  Future<List<dynamic>> getAll(String url) async {
    return await api.getall(url);
  }

  Future<List<dynamic>> getByParentId(String url, String id ) async {
    return await api.getByParentId(url, id);
  }

  Future<dynamic> save(String url, Object object) async {
    return await api.save(url, object);
  }

  Future<dynamic> savesub(String url, Object object, String id) async {
    return await api.savesub(url, object, id);
  }

  Future<List<dynamic>> saveList(String url,List<dynamic> list) async {
    return await api.saveList(url, list);
  }

  Future<bool> deleteById(String url, String id) async{
    return await api.delete(url, id);
  }

  Future<bool> deleteActive(String url, String id) async {
    return await api.deleteActive(url, id);
  }

  Future<dynamic> removethroughtParent(String url, String id) async {
    return await api.removethroughtParent(url, id);
  }

  Future<dynamic> saveImage(
      String url, Uint8List data, Map<String, dynamic> param, String name) async {
    return await api.saveImage(url, data, param, name);
  }


}