import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authentication {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String expiresIn;
  final int otpType;
  final String clientId;

  Authentication(this.accessToken, this.refreshToken, this.tokenType,
      this.expiresIn, this.otpType, this.clientId);

  // Getter for token
  static Future<String?> getToken() async {
    const _storage = FlutterSecureStorage();
    var token = await _storage.read(key: "token");
    return token;
  }

  // Save user token to secure storage
  static setToken(String token) async {
    const _storage = FlutterSecureStorage();
    var readData = _storage.write(key: "token", value: token);
    return readData;
  }

  // Getter for refresh token
  static Future getRefreshToken() async {
    const _storage = FlutterSecureStorage();
    var refreshToken = await _storage.read(key: "refreshToken");
    return refreshToken;
  }

  // Save user refresh token to secure storage
  static setRefreshToken(String token) async {
    const _storage = FlutterSecureStorage();
    var readData = _storage.write(key: "refreshToken", value: token);
    return readData;
  }

  TwoFactorAuthenticationType get type {
    switch (otpType) {
      case 1:
        return TwoFactorAuthenticationType.email;
      case 2:
        return TwoFactorAuthenticationType.sms;
      case 3:
        return TwoFactorAuthenticationType.googleAuthenticator;
      default:
        return TwoFactorAuthenticationType.none;
    }
  }
}

enum TwoFactorAuthenticationType { none, email, sms, googleAuthenticator }
