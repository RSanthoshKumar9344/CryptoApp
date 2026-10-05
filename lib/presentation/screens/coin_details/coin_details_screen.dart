import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/coin_details/coin_details_cubit.dart';
import '../../bloc/coin_details/coin_details_state.dart';
import '../../bloc/watchlist/watchlist_cubit.dart';
import '../../bloc/watchlist/watchlist_state.dart';
import '../../bloc/market/market_cubit.dart';
import '../../../data/repositories/crypto_repository.dart';
import '../../../core/widgets/crypto_logo.dart';
import '../../../core/widgets/price_change_chip.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/utils/currency_formatter.dart';
import 'widgets/price_chart.dart';
import 'widgets/chart_period_selector.dart';

class CoinDetailsScreen extends StatelessWidget {
  final String coinId;

  const CoinDetailsScreen({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<CryptoRepository>();

    return BlocProvider(
      create: (_) => CoinDetailsCubit(repo)..loadCoinDetails(coinId),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: BlocBuilder<CoinDetailsCubit, CoinDetailsState>(
            builder: (context, state) {
              if (state.details == null) {
                return const SizedBox.shrink();
              }
              final coin = state.details!.coin;
              return Row(
                children: [
                  CryptoLogo(
                    symbol: coin.symbol,
                    imageUrl: coin.imageUrl,
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        coin.symbol,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            BlocBuilder<CoinDetailsCubit, CoinDetailsState>(
              builder: (context, detailsState) {
                if (detailsState.details == null) {
                  return const SizedBox.shrink();
                }
                final coin = detailsState.details!.coin;

                return BlocBuilder<WatchlistCubit, WatchlistState>(
                  builder: (context, watchlistState) {
                    final isSaved = watchlistState.isWatchlisted(coin.id);
                    return IconButton(
                      icon: Icon(
                        isSaved
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: isSaved ? Colors.amber : null,
                        size: 26,
                      ),
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
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocBuilder<CoinDetailsCubit, CoinDetailsState>(
          builder: (context, state) {
            if (state.status == CoinDetailsStatus.loading &&
                state.details == null) {
              return _buildLoadingSkeleton();
            }

            if (state.status == CoinDetailsStatus.error ||
                state.details == null) {
              return ErrorStateWidget(
                onRetry: () =>
                    context.read<CoinDetailsCubit>().loadCoinDetails(coinId),
              );
            }

            final details = state.details!;
            final coin = details.coin;
            final isPos = coin.priceChangePercentage24h >= 0;

            final displayPrice = state.selectedChartPoint != null
                ? state.selectedChartPoint!.price
                : coin.currentPrice;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        CurrencyFormatter.formatCurrency(displayPrice),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 12),
                      PriceChangeChip(
                        priceChangePercentage: coin.priceChangePercentage24h,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.selectedChartPoint != null
                        ? 'Selected historical point'
                        : 'Current Market Price',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price Chart
                  PriceChart(
                    chartPoints: state.chartData,
                    isPositive: isPos,
                    onSpotSelected: (point) {
                      context.read<CoinDetailsCubit>().selectChartPoint(point);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Timeframe Selector
                  ChartPeriodSelector(
                    selectedPeriod: state.selectedPeriod,
                    onPeriodSelected: (period) {
                      context.read<CoinDetailsCubit>().changePeriod(
                        coin.id,
                        period,
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Market Statistics Section
                  const SectionHeader(title: 'Market Statistics'),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.6,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      StatCard(
                        label: 'Market Cap',
                        value: CurrencyFormatter.formatCompactCurrency(
                          coin.marketCap,
                        ),
                        icon: Icons.pie_chart_outline_rounded,
                      ),
                      StatCard(
                        label: '24h Trading Volume',
                        value: CurrencyFormatter.formatCompactCurrency(
                          coin.totalVolume,
                        ),
                        icon: Icons.bar_chart_rounded,
                      ),
                      StatCard(
                        label: '24h High',
                        value: CurrencyFormatter.formatCurrency(
                          details.high24h,
                        ),
                        icon: Icons.arrow_upward_rounded,
                      ),
                      StatCard(
                        label: '24h Low',
                        value: CurrencyFormatter.formatCurrency(details.low24h),
                        icon: Icons.arrow_downward_rounded,
                      ),
                      StatCard(
                        label: 'Circulating Supply',
                        value: CurrencyFormatter.formatCompactNumber(
                          coin.circulatingSupply,
                          symbol: coin.symbol,
                        ),
                        icon: Icons.donut_large_rounded,
                      ),
                      StatCard(
                        label: 'Total Supply',
                        value: coin.totalSupply != null
                            ? CurrencyFormatter.formatCompactNumber(
                                coin.totalSupply!,
                                symbol: coin.symbol,
                              )
                            : '∞ Infinite',
                        icon: Icons.all_inclusive_rounded,
                      ),
                      StatCard(
                        label: 'Market Rank',
                        value: '#${coin.marketCapRank}',
                        icon: Icons.military_tech_rounded,
                      ),
                      StatCard(
                        label: 'All-Time High (ATH)',
                        value: CurrencyFormatter.formatCurrency(details.ath),
                        icon: Icons.workspace_premium_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // About Section
                  SectionHeader(title: 'About ${coin.name}'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      details.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonContainer(width: 180, height: 36),
          const SizedBox(height: 20),
          const SkeletonContainer(
            width: double.infinity,
            height: 220,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          const SizedBox(height: 16),
          const SkeletonContainer(
            width: double.infinity,
            height: 40,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          const SizedBox(height: 28),
          const SkeletonContainer(width: 160, height: 20),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: List.generate(
              6,
              (_) => const SkeletonContainer(
                width: double.infinity,
                height: 80,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
