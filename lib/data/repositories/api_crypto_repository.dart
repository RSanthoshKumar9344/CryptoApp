import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/coin.dart';
import '../models/coin_details.dart';
import '../models/chart_point.dart';
import '../models/market_statistics.dart';
import 'crypto_repository.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException: $message ${statusCode != null ? '(Code: $statusCode)' : ''}';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class ParseException implements Exception {
  final String message;

  ParseException(this.message);

  @override
  String toString() => 'ParseException: $message';
}

class ApiCryptoRepository implements CryptoRepository {
  final String baseUrl;
  final http.Client _client;

  ApiCryptoRepository({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? ApiConstants.defaultBaseUrl,
        _client = client ?? http.Client();

  @override
  Future<List<Coin>> getCoins() async {
    final uri = Uri.parse('$baseUrl${ApiConstants.coins}');
    final json = await _performGetRequest(uri);

    if (json is! List) {
      throw ParseException('Expected a JSON list of coins from $uri');
    }

    try {
      return json
          .map((item) => Coin.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ParseException('Failed to parse coins list: $e');
    }
  }

  @override
  Future<CoinDetails> getCoinDetails(String coinId) async {
    final uri = Uri.parse('$baseUrl${ApiConstants.coinDetails(coinId)}');
    final json = await _performGetRequest(uri);

    if (json is! Map<String, dynamic>) {
      throw ParseException('Expected a JSON object for coin details from $uri');
    }

    try {
      return CoinDetails.fromJson(json);
    } catch (e) {
      throw ParseException('Failed to parse coin details for $coinId: $e');
    }
  }

  @override
  Future<List<ChartPoint>> getChartData(String coinId, String period) async {
    final uri = Uri.parse('$baseUrl${ApiConstants.coinChart(coinId, period)}');
    final json = await _performGetRequest(uri);

    if (json is! List) {
      throw ParseException('Expected a JSON list of chart points from $uri');
    }

    try {
      return json
          .map((item) => ChartPoint.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ParseException('Failed to parse chart points: $e');
    }
  }

  @override
  Future<MarketStatistics> getMarketStatistics() async {
    final uri = Uri.parse('$baseUrl${ApiConstants.marketStats}');
    final json = await _performGetRequest(uri);

    if (json is! Map<String, dynamic>) {
      throw ParseException(
        'Expected a JSON object for market statistics from $uri',
      );
    }

    try {
      return MarketStatistics.fromJson(json);
    } catch (e) {
      throw ParseException('Failed to parse market statistics: $e');
    }
  }

  Future<dynamic> _performGetRequest(Uri uri) async {
    try {
      debugPrint('🌐 Fetching API URL: $uri');
      final response = await _client
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(ApiConstants.requestTimeout);

      debugPrint('📡 Response Status: ${response.statusCode} | Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase ?? "Request failed"}',
          response.statusCode,
        );
      }
    } on SocketException catch (e) {
      debugPrint('❌ Network Socket Error: $e');
      throw NetworkException(
        'Unable to reach server at $baseUrl. Check network connection. ($e)',
      );
    } on TimeoutException {
      debugPrint('❌ Network Timeout Error');
      throw NetworkException('Connection timeout while requesting $uri');
    } on FormatException catch (e) {
      debugPrint('❌ JSON Format Error: $e');
      throw ParseException('Invalid JSON payload received from server: $e');
    }
  }
}
