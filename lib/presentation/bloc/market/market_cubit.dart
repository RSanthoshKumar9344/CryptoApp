import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/coin.dart';
import '../../../data/repositories/crypto_repository.dart';
import 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  final CryptoRepository repository;

  MarketCubit(this.repository) : super(const MarketState());

  Future<void> loadMarketData() async {
    emit(state.copyWith(status: MarketStatus.loading));
    try {
      final coins = await repository.getCoins();
      final stats = await repository.getMarketStatistics();

      final processed = _applyFiltersAndSort(
        coins: coins,
        query: state.searchQuery,
        sortField: state.sortField,
        sortOrder: state.sortOrder,
        priceFilter: state.priceChangeFilter,
        capFilter: state.marketCapFilter,
        rankFilter: state.rankFilter,
      );

      emit(
        state.copyWith(
          status: MarketStatus.loaded,
          allCoins: coins,
          filteredCoins: processed,
          marketStatistics: stats,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MarketStatus.error,
          errorMessage: 'Failed to load market data. Please try again.',
        ),
      );
    }
  }

  Future<void> refresh() async {
    await loadMarketData();
  }

  void searchCoins(String query) {
    final processed = _applyFiltersAndSort(
      coins: state.allCoins,
      query: query,
      sortField: state.sortField,
      sortOrder: state.sortOrder,
      priceFilter: state.priceChangeFilter,
      capFilter: state.marketCapFilter,
      rankFilter: state.rankFilter,
    );

    emit(state.copyWith(searchQuery: query, filteredCoins: processed));
  }

  void updateSorting(SortField field, SortOrder order) {
    final processed = _applyFiltersAndSort(
      coins: state.allCoins,
      query: state.searchQuery,
      sortField: field,
      sortOrder: order,
      priceFilter: state.priceChangeFilter,
      capFilter: state.marketCapFilter,
      rankFilter: state.rankFilter,
    );

    emit(
      state.copyWith(
        sortField: field,
        sortOrder: order,
        filteredCoins: processed,
      ),
    );
  }

  void applyFilters({
    PriceChangeFilter? priceFilter,
    MarketCapFilter? capFilter,
    RankFilter? rankFilter,
  }) {
    final newPriceFilter = priceFilter ?? state.priceChangeFilter;
    final newCapFilter = capFilter ?? state.marketCapFilter;
    final newRankFilter = rankFilter ?? state.rankFilter;

    final processed = _applyFiltersAndSort(
      coins: state.allCoins,
      query: state.searchQuery,
      sortField: state.sortField,
      sortOrder: state.sortOrder,
      priceFilter: newPriceFilter,
      capFilter: newCapFilter,
      rankFilter: newRankFilter,
    );

    emit(
      state.copyWith(
        priceChangeFilter: newPriceFilter,
        marketCapFilter: newCapFilter,
        rankFilter: newRankFilter,
        filteredCoins: processed,
      ),
    );
  }

  void resetFilters() {
    applyFilters(
      priceFilter: PriceChangeFilter.all,
      capFilter: MarketCapFilter.all,
      rankFilter: RankFilter.all,
    );
  }

  List<Coin> _applyFiltersAndSort({
    required List<Coin> coins,
    required String query,
    required SortField sortField,
    required SortOrder sortOrder,
    required PriceChangeFilter priceFilter,
    required MarketCapFilter capFilter,
    required RankFilter rankFilter,
  }) {
    var result = List<Coin>.from(coins);

    // Search filter
    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((c) {
        return c.name.toLowerCase().contains(q) ||
            c.symbol.toLowerCase().contains(q);
      }).toList();
    }

    // Price change filter
    if (priceFilter == PriceChangeFilter.positive) {
      result = result.where((c) => c.priceChangePercentage24h >= 0).toList();
    } else if (priceFilter == PriceChangeFilter.negative) {
      result = result.where((c) => c.priceChangePercentage24h < 0).toList();
    }

    // Market cap filter
    if (capFilter == MarketCapFilter.large) {
      result = result.where((c) => c.marketCap >= 1e10).toList(); // > $10B
    } else if (capFilter == MarketCapFilter.mid) {
      result = result
          .where((c) => c.marketCap >= 1e9 && c.marketCap < 1e10)
          .toList(); // $1B-$10B
    } else if (capFilter == MarketCapFilter.small) {
      result = result.where((c) => c.marketCap < 1e9).toList(); // < $1B
    }

    // Rank filter
    if (rankFilter == RankFilter.top10) {
      result = result.where((c) => c.marketCapRank <= 10).toList();
    } else if (rankFilter == RankFilter.top50) {
      result = result.where((c) => c.marketCapRank <= 50).toList();
    } else if (rankFilter == RankFilter.top100) {
      result = result.where((c) => c.marketCapRank <= 100).toList();
    }

    // Sorting
    result.sort((a, b) {
      int comparison = 0;
      switch (sortField) {
        case SortField.marketCap:
          comparison = a.marketCap.compareTo(b.marketCap);
          break;
        case SortField.price:
          comparison = a.currentPrice.compareTo(b.currentPrice);
          break;
        case SortField.change24h:
          comparison = a.priceChangePercentage24h.compareTo(
            b.priceChangePercentage24h,
          );
          break;
        case SortField.volume:
          comparison = a.totalVolume.compareTo(b.totalVolume);
          break;
        case SortField.rank:
          comparison = a.marketCapRank.compareTo(b.marketCapRank);
          break;
      }
      return sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return result;
  }
}
