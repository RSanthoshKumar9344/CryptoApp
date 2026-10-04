import 'package:flutter/material.dart';

import '../../../../data/models/market_statistics.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/price_change_chip.dart';

class MarketSummaryHeader extends StatelessWidget {
  final MarketStatistics stats;

  const MarketSummaryHeader({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            width: 170,
            child: StatCard(
              label: 'Total Market Cap',
              value: CurrencyFormatter.formatCompactCurrency(
                stats.totalMarketCap,
              ),
              icon: Icons.pie_chart_outline_rounded,
              trailing: PriceChangeChip(
                priceChangePercentage: stats.marketCapChange24h,
                compact: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: StatCard(
              label: '24h Volume',
              value: CurrencyFormatter.formatCompactCurrency(
                stats.total24hVolume,
              ),
              icon: Icons.bar_chart_rounded,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 150,
            child: StatCard(
              label: 'BTC Dominance',
              value: '${stats.btcDominance.toStringAsFixed(1)}%',
              icon: Icons.currency_bitcoin_rounded,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 150,
            child: StatCard(
              label: 'Active Cryptos',
              value: '${stats.activeCryptocurrencies}',
              icon: Icons.token_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
