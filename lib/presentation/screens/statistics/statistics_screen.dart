import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/statistics/statistics_cubit.dart';
import '../../bloc/statistics/statistics_state.dart';
import '../../widgets/crypto_list_tile.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/utils/currency_formatter.dart';
import '../coin_details/coin_details_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state.status == StatisticsStatus.loading &&
                state.marketStatistics == null) {
              return _buildLoadingSkeleton();
            }

            if (state.status == StatisticsStatus.error ||
                state.marketStatistics == null) {
              return ErrorStateWidget(
                onRetry: () => context.read<StatisticsCubit>().loadStatistics(),
              );
            }

            final stats = state.marketStatistics!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Market Overview',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Global cryptocurrency market statistics',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.6,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      StatCard(
                        label: 'Total Market Cap',
                        value: CurrencyFormatter.formatCompactCurrency(
                          stats.totalMarketCap,
                        ),
                        subtitle:
                            '${CurrencyFormatter.formatPercentage(stats.marketCapChange24h)} 24h',
                        icon: Icons.pie_chart_outline_rounded,
                      ),
                      StatCard(
                        label: '24h Trading Volume',
                        value: CurrencyFormatter.formatCompactCurrency(
                          stats.total24hVolume,
                        ),
                        icon: Icons.bar_chart_rounded,
                      ),
                      StatCard(
                        label: 'BTC Dominance',
                        value: '${stats.btcDominance.toStringAsFixed(1)}%',
                        icon: Icons.currency_bitcoin_rounded,
                      ),
                      StatCard(
                        label: 'Active Cryptos',
                        value: '${stats.activeCryptocurrencies}',
                        icon: Icons.token_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Market Performance Header & Tabs
                  const SectionHeader(title: 'Market Performance'),
                  const SizedBox(height: 8),

                  TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: 'Top Gainers'),
                      Tab(text: 'Top Losers'),
                      Tab(text: 'Top Volume'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tab View Content
                  SizedBox(
                    height: 380,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildCoinList(context, state.topGainers),
                        _buildCoinList(context, state.topLosers),
                        _buildCoinList(context, state.topVolume),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCoinList(BuildContext context, List coins) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coins.length,
      itemBuilder: (context, index) {
        final coin = coins[index];
        return CryptoListTile(
          coin: coin,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CoinDetailsScreen(coinId: coin.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonContainer(width: 220, height: 28),
          const SizedBox(height: 8),
          const SkeletonContainer(width: 280, height: 16),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: List.generate(
              4,
              (_) => const SkeletonContainer(
                width: double.infinity,
                height: 80,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const SkeletonContainer(width: 180, height: 20),
          const SizedBox(height: 16),
          ...List.generate(4, (_) => const CryptoListTileSkeleton()),
        ],
      ),
    );
  }
}
