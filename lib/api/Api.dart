import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:onlinestoredashboard/models/UiO.dart';


class Api {
  Map<String, String> header = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, DELETE',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept'
  };
  var _formatterToSend = new DateFormat('yyyy-MM-dd HH:mm:ss');

  Future<dynamic> getfirst(String url) async {
    Uri uri = Uri.parse("${UiO.url}${url}");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> getRatefirst(String url, DateTime dateTime) async {
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
    Uri uri = Uri.parse("${UiO.url}${url}");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Error");
    }
  }

  Future<List<dynamic>> getByParentId(String url, String id) async {
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
    Uri uri = Uri.parse("${UiO.url}${url}");

    final response =
        await http.post(uri, body: json.encode(object), headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return json; //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> savesub(String url, Object object, String id) async {
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
    List<int> list = data;
    final uri = Uri.parse('${UiO.url}${url}');
    var request = await http.MultipartRequest('POST', uri);
    param.forEach((key, value) {
      request.fields[key] = value;
    });

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

  Future<bool> delete(String url, String id) async {
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
