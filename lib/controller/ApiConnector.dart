import 'package:get/get.dart';
import 'package:onlinestoredashboard/api/Api.dart';

class ApiConnector extends GetConnect{

  final api = Api();

  Future<dynamic> getfirst(String url) async {
    final json = await api.getfirst(url);

    return json;
  }
}