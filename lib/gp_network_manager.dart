library gp_network_manager;

import 'package:gp_network_manager/helpers/helpers.dart';
import 'package:gp_network_manager/models/gp_network_configuration.dart';
import 'package:gp_network_manager/models/http_headers.dart';
import 'package:gp_network_manager/models/logger.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'models/gp_network_exceptoin.dart';
import 'models/authentication.dart';

abstract class GPNetworkManager {
  // static final GPNetworkManager _shared =
  //     GPNetworkManager(GPNetworkConfiguration("", 3));
  // static GPNetworkManager get shared => _shared;

  GPNetworkManager(this.config);

  final GPNetworkConfiguration config;

  Future<dynamic> get(String path, {HTTPHeaders? headers}) async {
    http.Response responseJson;

    try {
      final url = config.baseURL + path;
      NetworkLogger.callingAPILog(url);

      // Define request headers
      var requestHeaders = await addNeccesseraHeaders();
      print(requestHeaders);
      requestHeaders?.append(headers);

      // Send request
      final response =
          await http.get(Uri.parse(url), headers: requestHeaders?.toHeader());
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String path,
      {HTTPHeaders? headers, Object? body}) async {
    dynamic responseJson;

    try {
      final url = config.baseURL + path;
      NetworkLogger.callingAPILog(url);

      // Define request headers
      var requestHeaders = await addNeccesseraHeaders();
      requestHeaders?.append(headers);
      // Send request
      final response = await http.post(Uri.parse(url),
          headers: requestHeaders?.toHeader(), body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

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

extension AddTokenToHeaders on GPNetworkManager {
  Future<String?> addTokenToRequestHeaders() async {
    String? header;
    final token = await Authentication.getToken();
    if (token?.isNotEmpty == true) {
      header = "Bearer " + token!;
      return header;
    } else {
      return null;
    }
  }

  Future<HTTPHeaders?> addNeccesseraHeaders() async {
    HTTPHeaders? headers;
    // Add token if token exists
    var token = await addTokenToRequestHeaders();
    if (token != null) {
      headers?.add(HTTPHeader.bearerAuthorization(token));
    }

    // Add config default headers to request
    if (config.defaultHeaders != null) {
      headers = HTTPHeaders([]);
      for (var element in config.defaultHeaders!.headers()) {
        headers.add(element);
      }
    }
    return headers;
  }
}
