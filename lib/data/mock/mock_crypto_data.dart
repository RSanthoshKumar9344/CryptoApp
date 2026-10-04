import 'dart:math';

import '../models/coin.dart';
import '../models/coin_details.dart';
import '../models/chart_point.dart';
import '../models/market_statistics.dart';

abstract class MockCryptoData {
  static const List<Coin> coins = [
    Coin(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      currentPrice: 67421.20,
      priceChangePercentage24h: 2.43,
      marketCap: 1320000000000,
      marketCapRank: 1,
      totalVolume: 42800000000,
      circulatingSupply: 19700000,
      totalSupply: 21000000,
    ),
    Coin(
      id: 'ethereum',
      symbol: 'ETH',
      name: 'Ethereum',
      currentPrice: 3542.80,
      priceChangePercentage24h: 3.12,
      marketCap: 425000000000,
      marketCapRank: 2,
      totalVolume: 21500000000,
      circulatingSupply: 120200000,
      totalSupply: null,
    ),
    Coin(
      id: 'tether',
      symbol: 'USDT',
      name: 'Tether',
      currentPrice: 1.00,
      priceChangePercentage24h: 0.01,
      marketCap: 114000000000,
      marketCapRank: 3,
      totalVolume: 58200000000,
      circulatingSupply: 114000000000,
      totalSupply: 114000000000,
    ),
    Coin(
      id: 'binancecoin',
      symbol: 'BNB',
      name: 'BNB',
      currentPrice: 584.10,
      priceChangePercentage24h: -0.85,
      marketCap: 87500000000,
      marketCapRank: 4,
      totalVolume: 1240000000,
      circulatingSupply: 149800000,
      totalSupply: 149800000,
    ),
    Coin(
      id: 'solana',
      symbol: 'SOL',
      name: 'Solana',
      currentPrice: 148.60,
      priceChangePercentage24h: 5.82,
      marketCap: 69200000000,
      marketCapRank: 5,
      totalVolume: 3850000000,
      circulatingSupply: 465800000,
      totalSupply: 582000000,
    ),
    Coin(
      id: 'ripple',
      symbol: 'XRP',
      name: 'XRP',
      currentPrice: 0.542,
      priceChangePercentage24h: 1.15,
      marketCap: 30500000000,
      marketCapRank: 6,
      totalVolume: 1120000000,
      circulatingSupply: 56200000000,
      totalSupply: 100000000000,
    ),
    Coin(
      id: 'usd-coin',
      symbol: 'USDC',
      name: 'USD Coin',
      currentPrice: 1.00,
      priceChangePercentage24h: 0.00,
      marketCap: 34200000000,
      marketCapRank: 7,
      totalVolume: 6100000000,
      circulatingSupply: 34200000000,
      totalSupply: 34200000000,
    ),
    Coin(
      id: 'cardano',
      symbol: 'ADA',
      name: 'Cardano',
      currentPrice: 0.385,
      priceChangePercentage24h: -1.42,
      marketCap: 13800000000,
      marketCapRank: 8,
      totalVolume: 340000000,
      circulatingSupply: 35800000000,
      totalSupply: 45000000000,
    ),
    Coin(
      id: 'avalanche-2',
      symbol: 'AVAX',
      name: 'Avalanche',
      currentPrice: 28.40,
      priceChangePercentage24h: 4.10,
      marketCap: 11200000000,
      marketCapRank: 9,
      totalVolume: 410000000,
      circulatingSupply: 395000000,
      totalSupply: 720000000,
    ),
    Coin(
      id: 'dogecoin',
      symbol: 'DOGE',
      name: 'Dogecoin',
      currentPrice: 0.124,
      priceChangePercentage24h: 8.75,
      marketCap: 18100000000,
      marketCapRank: 10,
      totalVolume: 1850000000,
      circulatingSupply: 145000000000,
      totalSupply: null,
    ),
    Coin(
      id: 'chainlink',
      symbol: 'LINK',
      name: 'Chainlink',
      currentPrice: 14.20,
      priceChangePercentage24h: 2.18,
      marketCap: 8600000000,
      marketCapRank: 11,
      totalVolume: 280000000,
      circulatingSupply: 608000000,
      totalSupply: 1000000000,
    ),
    Coin(
      id: 'polkadot',
      symbol: 'DOT',
      name: 'Polkadot',
      currentPrice: 6.85,
      priceChangePercentage24h: -2.05,
      marketCap: 9800000000,
      marketCapRank: 12,
      totalVolume: 195000000,
      circulatingSupply: 1430000000,
      totalSupply: null,
    ),
    Coin(
      id: 'matic-network',
      symbol: 'MATIC',
      name: 'Polygon',
      currentPrice: 0.521,
      priceChangePercentage24h: 0.95,
      marketCap: 5100000000,
      marketCapRank: 13,
      totalVolume: 165000000,
      circulatingSupply: 9800000000,
      totalSupply: 10000000000,
    ),
    Coin(
      id: 'litecoin',
      symbol: 'LTC',
      name: 'Litecoin',
      currentPrice: 74.30,
      priceChangePercentage24h: 1.20,
      marketCap: 5550000000,
      marketCapRank: 14,
      totalVolume: 320000000,
      circulatingSupply: 74800000,
      totalSupply: 84000000,
    ),
    Coin(
      id: 'shiba-inu',
      symbol: 'SHIB',
      name: 'Shiba Inu',
      currentPrice: 0.0000185,
      priceChangePercentage24h: 6.40,
      marketCap: 10900000000,
      marketCapRank: 15,
      totalVolume: 510000000,
      circulatingSupply: 589000000000000,
      totalSupply: 589000000000000,
    ),
  ];

  static const MarketStatistics marketStats = MarketStatistics(
    totalMarketCap: 2480000000000,
    total24hVolume: 89500000000,
    btcDominance: 53.2,
    activeCryptocurrencies: 14250,
    marketCapChange24h: 2.15,
  );

  static CoinDetails getCoinDetails(Coin coin) {
    final isPos = coin.priceChangePercentage24h >= 0;
    final delta =
        coin.currentPrice * (coin.priceChangePercentage24h.abs() / 100);
    final high = coin.currentPrice + (isPos ? delta * 0.8 : delta * 1.5);
    final low = coin.currentPrice - (isPos ? delta * 1.5 : delta * 0.8);
    final ath = coin.currentPrice * 1.45;
    final atl = coin.currentPrice * 0.08;

    return CoinDetails(
      coin: coin,
      high24h: high,
      low24h: low,
      ath: ath,
      atl: atl,
      priceChange24h: delta * (isPos ? 1 : -1),
      description:
          '${coin.name} (${coin.symbol}) is a decentralized cryptocurrency with a current market cap of \$${(coin.marketCap / 1e9).toStringAsFixed(2)} Billion. It is currently ranked #${coin.marketCapRank} among all active digital assets.',
    );
  }

  static List<ChartPoint> generateChartData(Coin coin, String period) {
    int pointsCount;
    Duration step;
    double volatility;

    switch (period.toUpperCase()) {
      case '1D':
        pointsCount = 24;
        step = const Duration(hours: 1);
        volatility = 0.012;
        break;
      case '7D':
        pointsCount = 28;
        step = const Duration(hours: 6);
        volatility = 0.035;
        break;
      case '30D':
        pointsCount = 30;
        step = const Duration(days: 1);
        volatility = 0.07;
        break;
      case '1Y':
      default:
        pointsCount = 52;
        step = const Duration(days: 7);
        volatility = 0.25;
        break;
    }

    final now = DateTime.now();
    final List<ChartPoint> points = [];
    final random = Random(coin.id.hashCode + period.hashCode);

    double currentPrice = coin.currentPrice;
    final double isPositiveTrend = coin.priceChangePercentage24h >= 0
        ? 1.0
        : -1.0;

    // Generate backwards so current price matches today
    List<double> prices = [currentPrice];
    for (int i = 1; i < pointsCount; i++) {
      final changePercent =
          (random.nextDouble() - 0.48 + (isPositiveTrend * 0.02)) * volatility;
      currentPrice = currentPrice / (1 + changePercent);
      prices.add(currentPrice);
    }

    prices = prices.reversed.toList();

    for (int i = 0; i < pointsCount; i++) {
      final time = now.subtract(step * (pointsCount - 1 - i));
      points.add(ChartPoint(timestamp: time, price: prices[i]));
    }

    return points;
  }
}
