import 'dart:io';

class ServerConstants {
  static var serverBaseUrl =
      Platform.isAndroid
          ? 'http://10.0.2.2:3001/insta_clone/api/v1'
          : 'http://localhost:3001/insta_clone/api/v1';

  static const auth = "auth";
  static const login = "login";
  static const register = "register";
}
