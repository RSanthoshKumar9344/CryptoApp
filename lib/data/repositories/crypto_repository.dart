import '../models/coin.dart';
import '../models/coin_details.dart';
import '../models/chart_point.dart';
import '../models/market_statistics.dart';

abstract class CryptoRepository {
  Future<List<Coin>> getCoins();
  Future<CoinDetails> getCoinDetails(String coinId);
  Future<List<ChartPoint>> getChartData(String coinId, String period);
  Future<MarketStatistics> getMarketStatistics();
}
