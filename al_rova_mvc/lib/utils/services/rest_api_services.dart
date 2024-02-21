import 'dart:convert';
import 'dart:io';

import 'package:al_rova_mvc/utils/helper/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiBaseHelper {
  final String apiBaseUrl = "https://rova_solutions.acelucid.com/api/";
  final String modelBaseUrl = "https://rova_model.acelucid.com/";

  //global key
  static GlobalKey<State> loaderKey = GlobalKey<State>();
// get api method
  // Future<dynamic> get(String endpoint) async {
  //   var responseJson;
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     //   "Authorization": token
  //   };

  //   try {
  //     final response =
  //         await http.get(Uri.parse(apiBaseUrl + endpoint), headers: headers);
  //     responseJson = _returnResponse(response);
  //   } on SocketException {
  //     throw FetchDataException("connection_error");
  //   }
  //   return responseJson;
  // }

  Future<dynamic> get(String endpoint) async {
    var sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString("token");
    print(token);
    final response = await http.get(
      Uri.parse('$apiBaseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $token'
      },
    );
    return _handleResponse(response);
  }

// post api method
  // Future<dynamic> post(String url, dynamic body) async {
  //   var responseJson;
  //   var headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/json"
  //   };

  //   try {
  //     final response = await http.post(Uri.parse(apiBaseUrl + url),
  //         body: jsonEncode(body), headers: headers);
  //     responseJson = _returnResponse(response);
  //   } on SocketException {
  //     //print('No net');
  //     throw FetchDataException("Connection error");
  //   }
  //   return responseJson;
  // }

  Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl$endpoint'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  // put api method
  Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    var sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString("token");
    final response = await http.put(
      Uri.parse('$apiBaseUrl$endpoint'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $token'
      },
    );
    return jsonDecode(response.body);
  }

  // patch api method
  Future<Map<String, dynamic>> patch(String endpoint, dynamic data) async {
    final response = await http.patch(
      Uri.parse('$apiBaseUrl$endpoint'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  // delete api method
  Future<Map<String, dynamic>> delete(String endpoint, dynamic data) async {
    final response = await http.delete(
      Uri.parse('$apiBaseUrl$endpoint'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

// file upload method call
  Future<dynamic> uploadImageMediaPostRequest(
      String filename, String url) async {
    String urls = "";
    if (url != null) {
      urls = url;
    }
    var responseJson;
    var sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString('token');
    try {
      Map<String, String> headers = {
        "accept": "application/json",
        "content-Type": "multipart/form-data"
      };

      var request =
          http.MultipartRequest('POST', Uri.parse(modelBaseUrl + urls));
      request.headers.addAll(headers);
      request.files.add(http.MultipartFile('file',
          File(filename).readAsBytes().asStream(), File(filename).lengthSync(),
          filename: filename.split("/").last));
      print("${request}");
      // var res = await request.send();

      // print("this is the response${res}");
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      responseJson = jsonDecode(response.body);
    } on SocketException {
      throw FetchDataException("Connection error");
    }
    return responseJson;
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.isRedirect) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 400:
      throw BadRequestException(errorHandler(response));
    case 401:
    case 403:
      throw UnauthorisedException(response.statusCode.toString());
    case 422:
    case 419:
      throw FetchDataException(errorHandler(response));
    default:
      throw FetchDataException(response.statusCode.toString());
    //'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

errorHandler(http.Response response) {
  var responseJson = json.decode(response.body.toString());
  final map = responseJson['errors'];
  if (!["", null, false, 0].contains(map)) {
    List errorsList = [];
    for (var key in map.keys) {
      errorsList.add(map[key]);
    }
    var errors = errorsList.expand((i) => i).toList();
    return errors.join('\n');
  } else {
    return responseJson['message'];
  }
}