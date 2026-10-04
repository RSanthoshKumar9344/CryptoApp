import 'package:equatable/equatable.dart';

import '../../../data/models/coin.dart';
import '../../../data/models/market_statistics.dart';

enum MarketStatus { initial, loading, loaded, error }

enum SortField { marketCap, price, change24h, volume, rank }

enum SortOrder { ascending, descending }

enum PriceChangeFilter { all, positive, negative }

enum MarketCapFilter { all, large, mid, small }

enum RankFilter { all, top10, top50, top100 }

class MarketState extends Equatable {
  final MarketStatus status;
  final List<Coin> allCoins;
  final List<Coin> filteredCoins;
  final MarketStatistics? marketStatistics;
  final String searchQuery;
  final SortField sortField;
  final SortOrder sortOrder;
  final PriceChangeFilter priceChangeFilter;
  final MarketCapFilter marketCapFilter;
  final RankFilter rankFilter;
  final String? errorMessage;

  const MarketState({
    this.status = MarketStatus.initial,
    this.allCoins = const [],
    this.filteredCoins = const [],
    this.marketStatistics,
    this.searchQuery = '',
    this.sortField = SortField.rank,
    this.sortOrder = SortOrder.ascending,
    this.priceChangeFilter = PriceChangeFilter.all,
    this.marketCapFilter = MarketCapFilter.all,
    this.rankFilter = RankFilter.all,
    this.errorMessage,
  });

  MarketState copyWith({
    MarketStatus? status,
    List<Coin>? allCoins,
    List<Coin>? filteredCoins,
    MarketStatistics? marketStatistics,
    String? searchQuery,
    SortField? sortField,
    SortOrder? sortOrder,
    PriceChangeFilter? priceChangeFilter,
    MarketCapFilter? marketCapFilter,
    RankFilter? rankFilter,
    String? errorMessage,
  }) {
    return MarketState(
      status: status ?? this.status,
      allCoins: allCoins ?? this.allCoins,
      filteredCoins: filteredCoins ?? this.filteredCoins,
      marketStatistics: marketStatistics ?? this.marketStatistics,
      searchQuery: searchQuery ?? this.searchQuery,
      sortField: sortField ?? this.sortField,
      sortOrder: sortOrder ?? this.sortOrder,
      priceChangeFilter: priceChangeFilter ?? this.priceChangeFilter,
      marketCapFilter: marketCapFilter ?? this.marketCapFilter,
      rankFilter: rankFilter ?? this.rankFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allCoins,
    filteredCoins,
    marketStatistics,
    searchQuery,
    sortField,
    sortOrder,
    priceChangeFilter,
    marketCapFilter,
    rankFilter,
    errorMessage,
  ];
}
