library gp_network_manager;

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:gp_network_manager/models/gp_network_configuration.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
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

      var _dio = Dio();

      // Add logger
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));

      // Add retrier
      _dio.interceptors.add(RetryInterceptor(
        dio: _dio,
        logPrint: print,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 2),
        ],
      ));
      _dio.options.headers = await _prepareRequestHeaders(headers);
      var response = await _dio.get(url);

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

      var _dio = Dio();

      // Add logger
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));

      // Add retrier
      _dio.interceptors.add(RetryInterceptor(
        dio: _dio,
        logPrint: print,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 2),
        ],
      ));

      _dio.options.headers = await _prepareRequestHeaders(headers);
      // Send request
      final response = await _dio.post(url, data: body);
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

      var _dio = Dio();

      // Add logger
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));

      // Add retrier
      _dio.interceptors.add(RetryInterceptor(
        dio: _dio,
        logPrint: print,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 2),
        ],
      ));

      _dio.options.headers = await _prepareRequestHeaders(headers);
      // Send request
      final response = await _dio.put(url, data: body);
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
  dynamic _response(dynamic response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.toString());
        switch (responseJson["successed"]) {
          case true:
            return responseJson;
          default:
            throw RequestErrorException(
                responseJson["1"]["messages"].toString());
        }
      case 400:
        throw BadRequestException();
      case 401:
      case 403:
        throw UnauthorisedException();
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
