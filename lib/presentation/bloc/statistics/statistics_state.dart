import 'package:equatable/equatable.dart';

import '../../../data/models/market_statistics.dart';
import '../../../data/models/coin.dart';

enum StatisticsStatus { initial, loading, loaded, error }

class StatisticsState extends Equatable {
  final StatisticsStatus status;
  final MarketStatistics? marketStatistics;
  final List<Coin> topGainers;
  final List<Coin> topLosers;
  final List<Coin> topVolume;

  const StatisticsState({
    this.status = StatisticsStatus.initial,
    this.marketStatistics,
    this.topGainers = const [],
    this.topLosers = const [],
    this.topVolume = const [],
  });

  StatisticsState copyWith({
    StatisticsStatus? status,
    MarketStatistics? marketStatistics,
    List<Coin>? topGainers,
    List<Coin>? topLosers,
    List<Coin>? topVolume,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      marketStatistics: marketStatistics ?? this.marketStatistics,
      topGainers: topGainers ?? this.topGainers,
      topLosers: topLosers ?? this.topLosers,
      topVolume: topVolume ?? this.topVolume,
    );
  }

  @override
  List<Object?> get props => [
    status,
    marketStatistics,
    topGainers,
    topLosers,
    topVolume,
  ];
}
