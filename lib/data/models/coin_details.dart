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
