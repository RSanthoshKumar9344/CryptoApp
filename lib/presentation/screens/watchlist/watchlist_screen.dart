import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/watchlist/watchlist_cubit.dart';
import '../../bloc/watchlist/watchlist_state.dart';
import '../../bloc/market/market_cubit.dart';
import '../../widgets/crypto_list_tile.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../coin_details/coin_details_screen.dart';

class WatchlistScreen extends StatelessWidget {
  final VoidCallback onNavigateToMarket;

  const WatchlistScreen({super.key, required this.onNavigateToMarket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Watchlist',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track your favorite cryptocurrencies',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Watchlist Content
            Expanded(
              child: BlocBuilder<WatchlistCubit, WatchlistState>(
                builder: (context, state) {
                  if (state.watchlistedCoins.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.star_border_rounded,
                      title: 'No coins in your watchlist',
                      message: 'Add cryptocurrencies to quickly track their market performance and price movements.',
                      actionLabel: 'Explore Markets',
                      onAction: onNavigateToMarket,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.watchlistedCoins.length,
                    itemBuilder: (context, index) {
                      final coin = state.watchlistedCoins[index];
                      return CryptoListTile(
                        coin: coin,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CoinDetailsScreen(coinId: coin.id),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          tooltip: 'Remove from Watchlist',
                          onPressed: () {
                            final allCoins = context
                                .read<MarketCubit>()
                                .state
                                .allCoins;
                            context.read<WatchlistCubit>().toggleWatchlist(
                              coin,
                              allCoins,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
