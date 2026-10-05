import 'package:flutter/foundation.dart';

abstract class ApiConstants {
  // Configurable port and base host URL
  static const int port = 8001;

  // Optional custom physical device IP (set your Mac Wi-Fi IP here if using a real phone, e.g., '192.168.1.105')
  static const String? physicalDeviceMacIp = '192.168.1.4';

  // Default base URL depending on platform / environment
  static String get defaultBaseUrl {
    if (physicalDeviceMacIp != null && physicalDeviceMacIp!.isNotEmpty) {
      return 'http://$physicalDeviceMacIp:$port/api/v1';
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:$port/api/v1';
    }
    return defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:$port/api/v1'
        : 'http://127.0.0.1:$port/api/v1';
  }

  static const Duration requestTimeout = Duration(seconds: 10);

  // Endpoint paths
  static const String coins = '/coins';
  static String coinDetails(String id) => '/coins/$id';
  static String coinChart(String id, String period) =>
      '/coins/$id/chart?period=$period';
  static const String marketStats = '/market/stats';
}
