import 'package:shared_preferences/shared_preferences.dart';

class WatchlistRepository {
  static const String _watchlistKey = 'user_watchlist_ids';
  final SharedPreferences prefs;

  WatchlistRepository(this.prefs);

  List<String> getWatchlistIds() {
    return prefs.getStringList(_watchlistKey) ??
        ['bitcoin', 'ethereum', 'solana'];
  }

  Future<bool> isWatchlisted(String coinId) async {
    final list = getWatchlistIds();
    return list.contains(coinId);
  }

  Future<List<String>> toggleWatchlist(String coinId) async {
    final list = List<String>.from(getWatchlistIds());
    if (list.contains(coinId)) {
      list.remove(coinId);
    } else {
      list.add(coinId);
    }
    await prefs.setStringList(_watchlistKey, list);
    return list;
  }
}
