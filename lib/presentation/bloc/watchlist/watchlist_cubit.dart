import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/coin.dart';
import '../../../data/repositories/watchlist_repository.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchlistRepository repository;

  WatchlistCubit(this.repository) : super(const WatchlistState());

  void loadWatchlist(List<Coin> allCoins) {
    final ids = repository.getWatchlistIds();
    final savedCoins = allCoins.where((c) => ids.contains(c.id)).toList();

    emit(
      state.copyWith(
        status: WatchlistStatus.loaded,
        watchlistIds: ids,
        watchlistedCoins: savedCoins,
      ),
    );
  }

  Future<void> toggleWatchlist(Coin coin, List<Coin> allCoins) async {
    final newIds = await repository.toggleWatchlist(coin.id);
    final savedCoins = allCoins.where((c) => newIds.contains(c.id)).toList();

    emit(state.copyWith(watchlistIds: newIds, watchlistedCoins: savedCoins));
  }
}
