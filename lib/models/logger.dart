import 'dart:developer' as developer;

class NetworkLogger {
  static errorLog(String? message, String? url, int? statusCode, Object body) {
    developer.log(
        '⚠️ Failure on: $url ,\nStatus Code: $statusCode \nMessage: $message \nbody: $body');
  }

  static callingAPILog(String? url) {
    developer.log('✅ Calling API: $url');
  }
}
