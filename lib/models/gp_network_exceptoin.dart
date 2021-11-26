/*
 gp_network_exceptoin.dart
 Created by Mohammadreza Khatibi (mohammadreza.me) - 2021.
 
 Copyright 2021 Mohammadreza Khatibi ~ http://mohammadreza.me
 Github: https://github.com/mohammadrezakhatibi
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

class GPNetworkException implements Exception {
  final String? _message;
  final String? _prefix;

  GPNetworkException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends GPNetworkException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends GPNetworkException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends GPNetworkException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends GPNetworkException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class RequestErrorException extends GPNetworkException {
  RequestErrorException([String? message]) : super(message, "");
}
