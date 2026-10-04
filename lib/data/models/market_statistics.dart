import 'package:equatable/equatable.dart';

class MarketStatistics extends Equatable {
  final double totalMarketCap;
  final double total24hVolume;
  final double btcDominance;
  final int activeCryptocurrencies;
  final double marketCapChange24h;

  const MarketStatistics({
    required this.totalMarketCap,
    required this.total24hVolume,
    required this.btcDominance,
    required this.activeCryptocurrencies,
    required this.marketCapChange24h,
  });

  @override
  List<Object?> get props => [
    totalMarketCap,
    total24hVolume,
    btcDominance,
    activeCryptocurrencies,
    marketCapChange24h,
  ];
}
