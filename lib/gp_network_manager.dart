library gp_network_manager;

import 'package:gp_network_manager/models/gp_network_configuration.dart';
import 'package:gp_network_manager/models/logger.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'models/gp_network_exceptoin.dart';
import 'models/authentication.dart';

typedef RequestHeader = Map<String, String>;

abstract class GPNetworkManager {
  GPNetworkManager(this.config);

  final GPNetworkConfiguration config;

  Future<dynamic> get(String path, {RequestHeader? headers}) async {
    dynamic responseJson;

    try {
      final url = config.baseURL + path;
      NetworkLogger.callingAPILog(url);

      // Define request headers
      var requestHeaders = await _prepareRequestHeaders(headers);

      // Send request
      final response = await http.get(Uri.parse(url), headers: requestHeaders);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String path,
      {RequestHeader? headers, Object? body}) async {
    dynamic responseJson;

    try {
      final url = config.baseURL + path;
      NetworkLogger.callingAPILog(url);

      // Define request headers
      var requestHeaders = await _prepareRequestHeaders(headers);

      // Send request
      final response =
          await http.post(Uri.parse(url), headers: requestHeaders, body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String path,
      {RequestHeader? headers, Object? body}) async {
    dynamic responseJson;

    try {
      final url = config.baseURL + path;
      NetworkLogger.callingAPILog(url);

      // Define request headers
      var requestHeaders = await _prepareRequestHeaders(headers);

      // Send request
      final response =
          await http.put(Uri.parse(url), headers: requestHeaders, body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String path,
      {RequestHeader? headers, Object? body}) async {
    dynamic responseJson;

    try {
      final url = config.baseURL + path;
      NetworkLogger.callingAPILog(url);

      // Define request headers
      var requestHeaders = await _prepareRequestHeaders(headers);

      // Send request
      final response = await http.delete(Uri.parse(url),
          headers: requestHeaders, body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patch(String path,
      {RequestHeader? headers, Object? body}) async {
    dynamic responseJson;

    try {
      final url = config.baseURL + path;
      NetworkLogger.callingAPILog(url);

      // Define request headers
      var requestHeaders = await _prepareRequestHeaders(headers);

      // Send request
      final response =
          await http.patch(Uri.parse(url), headers: requestHeaders, body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
}

extension AddTokenToHeaders on GPNetworkManager {
  Future<String?> _addTokenToRequestHeaders() async {
    String? header;
    final token = await Authentication.getToken();
    if (token?.isNotEmpty == true) {
      header = "Bearer " + token!;
      return header;
    } else {
      return null;
    }
  }

  Future<RequestHeader?> _addDefaultHeaders() async {
    RequestHeader? headers = {};
    // Add token if token exists
    var token = await _addTokenToRequestHeaders();
    if (token != null) {
      headers = {HttpHeaders.authorizationHeader: token};
    }

    // Add config default headers to request
    if (config.defaultHeaders != null) {
      for (var element in config.defaultHeaders!.keys) {
        headers[element] = config.defaultHeaders![element]!;
      }
    }
    return headers;
  }

  Future<RequestHeader?> _prepareRequestHeaders(RequestHeader? headers) async {
    // Define request headers
    RequestHeader? requestHeaders = await _addDefaultHeaders();

    // Add config default headers to request
    if (headers != null) {
      //headers = HTTPHeaders([]);
      for (var element in headers.keys) {
        requestHeaders?.update(element, (value) => headers[element]!);
      }
    }
    return requestHeaders;
  }
}

extension _Response on GPNetworkManager {
  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        switch (responseJson["successed"]) {
          case true:
            return responseJson;
          default:
            throw RequestErrorException(
                responseJson["1"]["messages"].toString());
        }
      case 400:
        NetworkLogger.errorLog(
            response.body.toString(),
            response.request?.url.toString(),
            response.statusCode,
            response.body);
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        NetworkLogger.errorLog(
            response.body.toString(),
            response.request?.url.toString(),
            response.statusCode,
            response.body);
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        NetworkLogger.errorLog(
            response.body.toString(),
            response.request?.url.toString(),
            response.statusCode,
            response.request!.headers.toString());
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
