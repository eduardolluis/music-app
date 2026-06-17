import 'dart:io';

class ServerConstants {
  static String serverURL = Platform.isAndroid ? 'http://10.0.22:8000' : 'http://127.0.0.1:8000';
}
