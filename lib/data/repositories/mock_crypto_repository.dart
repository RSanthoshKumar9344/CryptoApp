import 'dart:async';

import '../models/coin.dart';
import '../models/coin_details.dart';
import '../models/chart_point.dart';
import '../models/market_statistics.dart';
import '../mock/mock_crypto_data.dart';
import 'crypto_repository.dart';

class MockCryptoRepository implements CryptoRepository {
  final Duration simulatedDelay;

  MockCryptoRepository({
    this.simulatedDelay = const Duration(milliseconds: 350),
  });

  @override
  Future<List<Coin>> getCoins() async {
    if (simulatedDelay.inMilliseconds > 0) {
      await Future.delayed(simulatedDelay);
    }
    return List.of(MockCryptoData.coins);
  }

  @override
  Future<CoinDetails> getCoinDetails(String coinId) async {
    if (simulatedDelay.inMilliseconds > 0) {
      await Future.delayed(simulatedDelay);
    }
    final coin = MockCryptoData.coins.firstWhere(
      (c) => c.id == coinId,
      orElse: () => MockCryptoData.coins.first,
    );
    return MockCryptoData.getCoinDetails(coin);
  }

  @override
  Future<List<ChartPoint>> getChartData(String coinId, String period) async {
    if (simulatedDelay.inMilliseconds > 0) {
      await Future.delayed(simulatedDelay);
    }
    final coin = MockCryptoData.coins.firstWhere(
      (c) => c.id == coinId,
      orElse: () => MockCryptoData.coins.first,
    );
    return MockCryptoData.generateChartData(coin, period);
  }

  @override
  Future<MarketStatistics> getMarketStatistics() async {
    if (simulatedDelay.inMilliseconds > 0) {
      await Future.delayed(simulatedDelay);
    }
    return MockCryptoData.marketStats;
  }
}
