import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:cryptoapp/data/repositories/api_crypto_repository.dart';

void main() {
  group('ApiCryptoRepository Unit Tests', () {
    const baseUrl = 'http://127.0.0.1:8001/api/v1';

    test('getCoins returns list of coins on HTTP 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), '$baseUrl/coins');
        return http.Response(
          jsonEncode([
            {
              'id': 'bitcoin',
              'symbol': 'BTC',
              'name': 'Bitcoin',
              'currentPrice': 67421.20,
              'priceChangePercentage24h': 2.43,
              'marketCap': 1320000000000.0,
              'marketCapRank': 1,
              'totalVolume': 42800000000.0,
              'circulatingSupply': 19700000.0,
            },
          ]),
          200,
        );
      });

      final repo = ApiCryptoRepository(baseUrl: baseUrl, client: mockClient);
      final coins = await repo.getCoins();

      expect(coins.length, 1);
      expect(coins.first.name, 'Bitcoin');
      expect(coins.first.currentPrice, 67421.20);
    });

    test('getCoinDetails returns coin details on HTTP 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), '$baseUrl/coins/bitcoin');
        return http.Response(
          jsonEncode({
            'coin': {
              'id': 'bitcoin',
              'symbol': 'BTC',
              'name': 'Bitcoin',
              'currentPrice': 67421.20,
              'priceChangePercentage24h': 2.43,
              'marketCap': 1320000000000.0,
              'marketCapRank': 1,
              'totalVolume': 42800000000.0,
              'circulatingSupply': 19700000.0,
            },
            'high24h': 68000.0,
            'low24h': 66000.0,
            'ath': 73000.0,
            'atl': 67.0,
            'priceChange24h': 1600.0,
            'description': 'Bitcoin description',
          }),
          200,
        );
      });

      final repo = ApiCryptoRepository(baseUrl: baseUrl, client: mockClient);
      final details = await repo.getCoinDetails('bitcoin');

      expect(details.coin.name, 'Bitcoin');
      expect(details.high24h, 68000.0);
      expect(details.description, 'Bitcoin description');
    });

    test('getChartData returns historical chart points on HTTP 200', () async {
      final mockClient = MockClient((request) async {
        expect(
          request.url.toString(),
          '$baseUrl/coins/bitcoin/chart?period=1D',
        );
        return http.Response(
          jsonEncode([
            {'timestamp': '2024-10-25T14:30:00Z', 'price': 67421.20},
          ]),
          200,
        );
      });

      final repo = ApiCryptoRepository(baseUrl: baseUrl, client: mockClient);
      final chartPoints = await repo.getChartData('bitcoin', '1D');

      expect(chartPoints.length, 1);
      expect(chartPoints.first.price, 67421.20);
    });

    test('getMarketStatistics returns global stats on HTTP 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), '$baseUrl/market/stats');
        return http.Response(
          jsonEncode({
            'totalMarketCap': 2480000000000.0,
            'total24hVolume': 89500000000.0,
            'btcDominance': 53.2,
            'activeCryptocurrencies': 14250,
            'marketCapChange24h': 2.15,
          }),
          200,
        );
      });

      final repo = ApiCryptoRepository(baseUrl: baseUrl, client: mockClient);
      final stats = await repo.getMarketStatistics();

      expect(stats.totalMarketCap, 2480000000000.0);
      expect(stats.btcDominance, 53.2);
    });

    test('throws ApiException on non-200 HTTP response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final repo = ApiCryptoRepository(baseUrl: baseUrl, client: mockClient);

      expect(() => repo.getCoins(), throwsA(isA<ApiException>()));
    });

    test('throws ParseException on malformed JSON payload', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{ invalid json }', 200);
      });

      final repo = ApiCryptoRepository(baseUrl: baseUrl, client: mockClient);

      expect(() => repo.getCoins(), throwsA(isA<ParseException>()));
    });
  });
}
