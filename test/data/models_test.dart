import 'package:flutter_test/flutter_test.dart';
import 'package:cryptoapp/data/models/coin.dart';
import 'package:cryptoapp/data/models/coin_details.dart';
import 'package:cryptoapp/data/models/chart_point.dart';
import 'package:cryptoapp/data/models/market_statistics.dart';

void main() {
  group('Model JSON Parsing Tests', () {
    test('Coin.fromJson handles camelCase and snake_case correctly', () {
      final jsonCamel = {
        'id': 'bitcoin',
        'symbol': 'btc',
        'name': 'Bitcoin',
        'imageUrl': 'http://image.png',
        'currentPrice': 67421.20,
        'priceChangePercentage24h': 2.43,
        'marketCap': 1320000000000.0,
        'marketCapRank': 1,
        'totalVolume': 42800000000.0,
        'circulatingSupply': 19700000.0,
        'totalSupply': 21000000.0,
      };

      final coin = Coin.fromJson(jsonCamel);
      expect(coin.id, 'bitcoin');
      expect(coin.symbol, 'BTC');
      expect(coin.name, 'Bitcoin');
      expect(coin.currentPrice, 67421.20);
      expect(coin.marketCapRank, 1);
      expect(coin.totalSupply, 21000000.0);

      final jsonSnake = {
        'id': 'ethereum',
        'symbol': 'eth',
        'name': 'Ethereum',
        'image_url': 'http://eth.png',
        'current_price': 3500,
        'price_change_percentage_24h': -1.5,
        'market_cap': 400000000000,
        'market_cap_rank': 2,
        'total_volume': 20000000000,
        'circulating_supply': 120000000,
      };

      final coinSnake = Coin.fromJson(jsonSnake);
      expect(coinSnake.id, 'ethereum');
      expect(coinSnake.currentPrice, 3500.0);
      expect(coinSnake.priceChangePercentage24h, -1.5);
      expect(coinSnake.totalSupply, isNull);
    });

    test('CoinDetails.fromJson parses nested coin and metrics correctly', () {
      final json = {
        'coin': {
          'id': 'bitcoin',
          'symbol': 'btc',
          'name': 'Bitcoin',
          'currentPrice': 67000.0,
          'priceChangePercentage24h': 2.0,
          'marketCap': 1000000000.0,
          'marketCapRank': 1,
          'totalVolume': 50000000.0,
          'circulatingSupply': 19000000.0,
        },
        'high24h': 68000.0,
        'low24h': 66000.0,
        'ath': 73000.0,
        'atl': 67.0,
        'priceChange24h': 1300.0,
        'description': 'Decentralized digital currency',
      };

      final details = CoinDetails.fromJson(json);
      expect(details.coin.name, 'Bitcoin');
      expect(details.high24h, 68000.0);
      expect(details.low24h, 66000.0);
      expect(details.description, 'Decentralized digital currency');
    });

    test('ChartPoint.fromJson parses ISO-8601 strings and numbers', () {
      final json = {'timestamp': '2024-10-25T14:30:00.000Z', 'price': 67421.20};

      final point = ChartPoint.fromJson(json);
      expect(point.price, 67421.20);
      expect(point.timestamp.year, 2024);
      expect(point.timestamp.month, 10);
    });

    test('MarketStatistics.fromJson parses global statistics correctly', () {
      final json = {
        'totalMarketCap': 2480000000000.0,
        'total24hVolume': 89500000000.0,
        'btcDominance': 53.2,
        'activeCryptocurrencies': 14250,
        'marketCapChange24h': 2.15,
      };

      final stats = MarketStatistics.fromJson(json);
      expect(stats.totalMarketCap, 2480000000000.0);
      expect(stats.btcDominance, 53.2);
      expect(stats.activeCryptocurrencies, 14250);
    });
  });
}
