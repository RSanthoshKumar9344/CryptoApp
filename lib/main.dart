import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_theme.dart';
import 'data/repositories/crypto_repository.dart';
import 'data/repositories/api_crypto_repository.dart';
import 'data/repositories/watchlist_repository.dart';
import 'presentation/bloc/theme/theme_cubit.dart';
import 'presentation/bloc/market/market_cubit.dart';
import 'presentation/bloc/market/market_state.dart';
import 'presentation/bloc/watchlist/watchlist_cubit.dart';
import 'presentation/bloc/statistics/statistics_cubit.dart';
import 'presentation/navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Instantiate REST API repository connecting to Python FastAPI backend
  final CryptoRepository cryptoRepository = ApiCryptoRepository();
  final WatchlistRepository watchlistRepository = WatchlistRepository(prefs);

  runApp(
    CryptoApp(
      cryptoRepository: cryptoRepository,
      watchlistRepository: watchlistRepository,
      prefs: prefs,
    ),
  );
}

class CryptoApp extends StatelessWidget {
  final CryptoRepository cryptoRepository;
  final WatchlistRepository watchlistRepository;
  final SharedPreferences prefs;

  const CryptoApp({
    super.key,
    required this.cryptoRepository,
    required this.watchlistRepository,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CryptoRepository>.value(value: cryptoRepository),
        RepositoryProvider<WatchlistRepository>.value(
          value: watchlistRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(prefs)),
          BlocProvider<MarketCubit>(
            create: (_) => MarketCubit(cryptoRepository)..loadMarketData(),
          ),
          BlocProvider<WatchlistCubit>(
            create: (_) => WatchlistCubit(watchlistRepository),
          ),
          BlocProvider<StatisticsCubit>(
            create: (_) => StatisticsCubit(cryptoRepository)..loadStatistics(),
          ),
        ],
        child: BlocListener<MarketCubit, MarketState>(
          listenWhen: (previous, current) =>
              previous.allCoins.isEmpty && current.allCoins.isNotEmpty,
          listener: (context, state) {
            context.read<WatchlistCubit>().loadWatchlist(state.allCoins);
          },
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                title: 'Crypto Market & Research',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                home: const MainNavigationScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
