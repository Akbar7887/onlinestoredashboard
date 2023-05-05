import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onlinestoredashboard/controller/Controller.dart';
import 'package:onlinestoredashboard/models/UiO.dart';

class ApiConnector extends GetConnect {
  String? token;
  FlutterSecureStorage _storage = FlutterSecureStorage();

  Map<String, String> header = {
    'Content-Type': 'application/json; charset=utf-8',
    // 'charset': 'utf-8',
    // 'Accept': 'application/json',
  };
  var _formatterToSend = new DateFormat('yyyy-MM-dd HH:mm:ss');

  Future<bool> login(String user, String passwor) async {
    Map<String, String> data = {'username': user, 'password': passwor};
    Map<String, String> header1 = {
      "Content-Type": "application/x-www-form-urlencoded", //
      // "Authorization": "Bearer $token",
    };

    // final uri = Uri.parse();
    final uri = Uri.parse('${UiO.urllogin}login');
    var response = await http.post(uri,
        body: data, headers: header1, encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> login = jsonDecode(utf8.decode(response.bodyBytes));

       await _storage.write(key: 'token', value: login['access_token']);

      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> getfirst(String url) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Uri uri = Uri.parse("${UiO.url}${url}");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {

        return jsonDecode(utf8.decode(response.bodyBytes));

    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> getRatefirst(String url, DateTime dateTime) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Map<String, dynamic> param = {"date": _formatterToSend.format(dateTime)};
    Uri uri = Uri.parse("${UiO.url}${url}").replace(queryParameters: param);
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return json;
    } else {
      throw Exception("Error");
    }
  }

  Future<List<dynamic>> getall(String url) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Uri uri = Uri.parse("${UiO.url}${url}");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Error");
    }
  }

  Future<List<dynamic>> getByParentId(String url, String id) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Map<String, dynamic> param = {"id": id};
    Uri uri = Uri.parse("${UiO.url}${url}").replace(queryParameters: param);
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return json;
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> save(String url, Object object) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Uri uri = Uri.parse("${UiO.url}${url}");

    final response =
        await http.post(uri, body: jsonEncode(object), headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return json; //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> savesub(String url, Object object, String id) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Map<String, dynamic> param = {'id': id};

    Uri uri = Uri.parse("${UiO.url}${url}").replace(queryParameters: param);

    // Uri uri = Uri.https(UiO.url, url,{"id": id});
    final response =
        await http.post(uri, body: json.encode(object), headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return json; //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<List<dynamic>> saveList(String url, List<dynamic> list) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    // Map<String, dynamic> param = {'id': id};

    Uri uri = Uri.parse("${UiO.url}${url}");

    // Uri uri = Uri.https(UiO.url, url,{"id": id});
    final response =
        await http.post(uri, body: json.encode(list), headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return json; //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> saveImage(String url, Uint8List data,
      Map<String, dynamic> param, String name) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    List<int> list = data;
    final uri = Uri.parse('${UiO.url}${url}');
    var request = await http.MultipartRequest('POST', uri);
    param.forEach((key, value) {
      request.fields[key] = value;
    });
    request.headers.addAll(header);

    // request.fields["id"] = "";
    // request.fields["parent_id"] = "19";
    // request.fields["mainimg"] = "false";

    // request.headers.addAll(hedersWithToken);
    request.files
        .add(http.MultipartFile.fromBytes("file", list, filename: name));
    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = await http.Response.fromStream(response);
      return jsonDecode(utf8.decode(result.bodyBytes));
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> deleteActive(String url, String id) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Map<String, dynamic> param = {'id': id};

    Uri uri = Uri.parse("${UiO.url}${url}").replace(queryParameters: param);

    // Uri uri = Uri.https(UiO.url, url,{"id": id});
    final response = await http.put(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // final json = jsonDecode(utf8.decode(response.bodyBytes));
      //
      return true; //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      return false; //json.map((e) => Catalog.fromJson(e)).toList();

      throw Exception("Error");
    }
  }

  Future<dynamic> removethroughtParent(String url, String id) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Map<String, dynamic> param = {'id': id};

    Uri uri = Uri.parse("${UiO.url}${url}").replace(queryParameters: param);

    // Uri uri = Uri.https(UiO.url, url,{"id": id});
    final response = await http.post(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return json; //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<bool> deletebyId(String url, String id) async {
    token = await _storage.read(key: "token");
    header.addAll({"Authorization": "Bearer $token"});
    Uri uri =
        Uri.parse("${UiO.url}${url}").replace(queryParameters: {"id": id});

    final response = await http.delete(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Error");
    }
  }
}
