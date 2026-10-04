import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/market/market_cubit.dart';
import '../../bloc/market/market_state.dart';
import '../../widgets/crypto_list_tile.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import 'widgets/market_summary_header.dart';
import 'widgets/sort_bottom_sheet.dart';
import 'widgets/filter_bottom_sheet.dart';
import '../coin_details/coin_details_screen.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MarketCubit, MarketState>(
          builder: (context, state) {
            if (state.status == MarketStatus.loading &&
                state.allCoins.isEmpty) {
              return _buildLoadingSkeleton();
            }

            if (state.status == MarketStatus.error && state.allCoins.isEmpty) {
              return ErrorStateWidget(
                onRetry: () => context.read<MarketCubit>().loadMarketData(),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<MarketCubit>().refresh(),
              child: CustomScrollView(
                slivers: [
                  // App Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Crypto Market',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Track the latest cryptocurrency market movements',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Search Input
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: SearchField(
                        initialValue: state.searchQuery,
                        onChanged: (query) =>
                            context.read<MarketCubit>().searchCoins(query),
                        onClear: () =>
                            context.read<MarketCubit>().searchCoins(''),
                      ),
                    ),
                  ),

                  // Market Summary Stats
                  if (state.marketStatistics != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: MarketSummaryHeader(
                          stats: state.marketStatistics!,
                        ),
                      ),
                    ),

                  // Section Header with Sort & Filter Actions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: SectionHeader(
                        title: 'Markets (${state.filteredCoins.length})',
                        trailing: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.tune_rounded, size: 20),
                              tooltip: 'Filter',
                              onPressed: () {
                                FilterBottomSheet.show(
                                  context,
                                  currentPriceFilter: state.priceChangeFilter,
                                  currentCapFilter: state.marketCapFilter,
                                  currentRankFilter: state.rankFilter,
                                  onApply:
                                      ({priceFilter, capFilter, rankFilter}) {
                                        context
                                            .read<MarketCubit>()
                                            .applyFilters(
                                              priceFilter: priceFilter,
                                              capFilter: capFilter,
                                              rankFilter: rankFilter,
                                            );
                                      },
                                  onReset: () => context
                                      .read<MarketCubit>()
                                      .resetFilters(),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.swap_vert_rounded,
                                size: 22,
                              ),
                              tooltip: 'Sort',
                              onPressed: () {
                                SortBottomSheet.show(
                                  context,
                                  currentField: state.sortField,
                                  currentOrder: state.sortOrder,
                                  onApply: (field, order) {
                                    context.read<MarketCubit>().updateSorting(
                                      field,
                                      order,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Coins List / Empty State
                  if (state.filteredCoins.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: 'No cryptocurrencies found',
                        message: state.searchQuery.isNotEmpty
                            ? 'No coins match "${state.searchQuery}". Try searching with another name or symbol.'
                            : 'No coins match the selected filters. Try resetting your filter settings.',
                        actionLabel: 'Clear Filters',
                        onAction: () {
                          context.read<MarketCubit>().searchCoins('');
                          context.read<MarketCubit>().resetFilters();
                        },
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final coin = state.filteredCoins[index];
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
                          );
                        }, childCount: state.filteredCoins.length),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
          const SkeletonContainer(width: 200, height: 28),
          const SizedBox(height: 8),
          const SkeletonContainer(width: 280, height: 16),
          const SizedBox(height: 20),
          const SkeletonContainer(
            width: double.infinity,
            height: 48,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              SkeletonContainer(
                width: 140,
                height: 80,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              SizedBox(width: 12),
              SkeletonContainer(
                width: 140,
                height: 80,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SkeletonContainer(width: 120, height: 20),
          const SizedBox(height: 16),
          ...List.generate(6, (_) => const CryptoListTileSkeleton()),
        ],
      ),
    );
  }
}
