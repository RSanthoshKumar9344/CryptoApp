import 'package:equatable/equatable.dart';

import 'coin.dart';

class CoinDetails extends Equatable {
  final Coin coin;
  final double high24h;
  final double low24h;
  final double ath;
  final double atl;
  final String description;
  final double priceChange24h;

  const CoinDetails({
    required this.coin,
    required this.high24h,
    required this.low24h,
    required this.ath,
    required this.atl,
    required this.description,
    required this.priceChange24h,
  });

  Map<String, dynamic> toJson() {
    return {
      'coin': coin.toJson(),
      'high24h': high24h,
      'low24h': low24h,
      'ath': ath,
      'atl': atl,
      'description': description,
      'priceChange24h': priceChange24h,
    };
  }

  factory CoinDetails.fromJson(Map<String, dynamic> json) {
    final coinData = json['coin'] is Map<String, dynamic>
        ? json['coin'] as Map<String, dynamic>
        : json;
    final high = json['high24h'] ?? json['high_24h'] ?? 0.0;
    final low = json['low24h'] ?? json['low_24h'] ?? 0.0;
    final athVal = json['ath'] ?? 0.0;
    final atlVal = json['atl'] ?? 0.0;
    final pChange = json['priceChange24h'] ?? json['price_change_24h'] ?? 0.0;
    final desc = json['description'] as String? ?? '';

    return CoinDetails(
      coin: Coin.fromJson(coinData),
      high24h: (high as num).toDouble(),
      low24h: (low as num).toDouble(),
      ath: (athVal as num).toDouble(),
      atl: (atlVal as num).toDouble(),
      description: desc,
      priceChange24h: (pChange as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    coin,
    high24h,
    low24h,
    ath,
    atl,
    description,
    priceChange24h,
  ];
}
