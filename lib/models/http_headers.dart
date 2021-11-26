class HTTPHeader {
  final String name;
  final String value;

  HTTPHeader(this.name, this.value);

  static HTTPHeader accept(String value) {
    return HTTPHeader("Accept", value);
  }

  static HTTPHeader lang(String value) {
    return HTTPHeader("Lang", value);
  }

  static HTTPHeader xmode(String value) {
    return HTTPHeader("X-Mode", value);
  }

  static HTTPHeader xorigin(String value) {
    return HTTPHeader("X-Origin", value);
  }

  static HTTPHeader contentType(String value) {
    return HTTPHeader("Content-Type", value);
  }

  static HTTPHeader bearerAuthorization(String value) {
    return HTTPHeader("Authorization", "Bearer " + value);
  }
}

class HTTPHeaders {
  final List<HTTPHeader> _headers;
  HTTPHeaders(this._headers);

  add(HTTPHeader header) {
    _headers.add(header);
  }

  append(HTTPHeaders? headers) {
    if (headers?._headers != null) {
      for (var header in headers!._headers) {
        _headers.add(header);
      }
    }
  }

  Map<String, String> toHeader() {
    final Map<String, String> map = {};
    for (var element in _headers) {
      map[element.name] = element.value;
    }
    return map;
  }

  List<HTTPHeader> headers() {
    return _headers;
  }
}
