import 'dart:io';
import 'package:flutter/foundation.dart'; // Para kIsWeb

class APIConfig {
  static String get baseURL {
    // Se for Web
    if (kIsWeb) return 'http://127.0.0.1:8000';

    // Se for Android (Emulador)
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';

    // Se for iOS ou Linux/Windows/Mac Desktop
    return 'http://127.0.0.1:8000';
  }
}
