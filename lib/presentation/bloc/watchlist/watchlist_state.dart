import 'package:equatable/equatable.dart';

import '../../../data/models/coin.dart';

enum WatchlistStatus { initial, loading, loaded, error }

class WatchlistState extends Equatable {
  final WatchlistStatus status;
  final List<String> watchlistIds;
  final List<Coin> watchlistedCoins;

  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.watchlistIds = const [],
    this.watchlistedCoins = const [],
  });

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<String>? watchlistIds,
    List<Coin>? watchlistedCoins,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      watchlistIds: watchlistIds ?? this.watchlistIds,
      watchlistedCoins: watchlistedCoins ?? this.watchlistedCoins,
    );
  }

  bool isWatchlisted(String coinId) => watchlistIds.contains(coinId);

  @override
  List<Object?> get props => [status, watchlistIds, watchlistedCoins];
}
