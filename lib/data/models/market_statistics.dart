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

  Map<String, dynamic> toJson() {
    return {
      'totalMarketCap': totalMarketCap,
      'total24hVolume': total24hVolume,
      'btcDominance': btcDominance,
      'activeCryptocurrencies': activeCryptocurrencies,
      'marketCapChange24h': marketCapChange24h,
    };
  }

  factory MarketStatistics.fromJson(Map<String, dynamic> json) {
    final cap = json['totalMarketCap'] ?? json['total_market_cap'] ?? 0.0;
    final vol = json['total24hVolume'] ?? json['total_24h_volume'] ?? 0.0;
    final btc = json['btcDominance'] ?? json['btc_dominance'] ?? 0.0;
    final active =
        json['activeCryptocurrencies'] ?? json['active_cryptocurrencies'] ?? 0;
    final capChange =
        json['marketCapChange24h'] ?? json['market_cap_change_24h'] ?? 0.0;

    return MarketStatistics(
      totalMarketCap: (cap as num).toDouble(),
      total24hVolume: (vol as num).toDouble(),
      btcDominance: (btc as num).toDouble(),
      activeCryptocurrencies: (active as num).toInt(),
      marketCapChange24h: (capChange as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    totalMarketCap,
    total24hVolume,
    btcDominance,
    activeCryptocurrencies,
    marketCapChange24h,
  ];
}
