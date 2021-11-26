import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HashCode {
  // Get hash Code
  static Future get() async {
    const _storage = FlutterSecureStorage();
    var token = await _storage.read(key: "hashCode");
    return token;
  }

  // Save hashCode
  static set(String code) async {
    const _storage = FlutterSecureStorage();
    var readData = _storage.write(key: "hashCode", value: code);
    return readData;
  }
}
