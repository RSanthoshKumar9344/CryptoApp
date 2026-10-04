import 'package:flutter/material.dart';

import '../../../bloc/market/market_state.dart';

class FilterBottomSheet extends StatefulWidget {
  final PriceChangeFilter currentPriceFilter;
  final MarketCapFilter currentCapFilter;
  final RankFilter currentRankFilter;
  final Function({
    PriceChangeFilter? priceFilter,
    MarketCapFilter? capFilter,
    RankFilter? rankFilter,
  })
  onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.currentPriceFilter,
    required this.currentCapFilter,
    required this.currentRankFilter,
    required this.onApply,
    required this.onReset,
  });

  static void show(
    BuildContext context, {
    required PriceChangeFilter currentPriceFilter,
    required MarketCapFilter currentCapFilter,
    required RankFilter currentRankFilter,
    required Function({
      PriceChangeFilter? priceFilter,
      MarketCapFilter? capFilter,
      RankFilter? rankFilter,
    })
    onApply,
    required VoidCallback onReset,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        currentPriceFilter: currentPriceFilter,
        currentCapFilter: currentCapFilter,
        currentRankFilter: currentRankFilter,
        onApply: onApply,
        onReset: onReset,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late PriceChangeFilter _priceFilter;
  late MarketCapFilter _capFilter;
  late RankFilter _rankFilter;

  @override
  void initState() {
    super.initState();
    _priceFilter = widget.currentPriceFilter;
    _capFilter = widget.currentCapFilter;
    _rankFilter = widget.currentRankFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Cryptocurrencies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '24H PRICE CHANGE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _priceFilter == PriceChangeFilter.all,
                onSelected: (_) =>
                    setState(() => _priceFilter = PriceChangeFilter.all),
              ),
              ChoiceChip(
                label: const Text('Positive Gainers'),
                selected: _priceFilter == PriceChangeFilter.positive,
                onSelected: (_) =>
                    setState(() => _priceFilter = PriceChangeFilter.positive),
              ),
              ChoiceChip(
                label: const Text('Negative Losers'),
                selected: _priceFilter == PriceChangeFilter.negative,
                onSelected: (_) =>
                    setState(() => _priceFilter = PriceChangeFilter.negative),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'MARKET CAP TIER',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All Caps'),
                selected: _capFilter == MarketCapFilter.all,
                onSelected: (_) =>
                    setState(() => _capFilter = MarketCapFilter.all),
              ),
              ChoiceChip(
                label: const Text('Large Cap (>\$10B)'),
                selected: _capFilter == MarketCapFilter.large,
                onSelected: (_) =>
                    setState(() => _capFilter = MarketCapFilter.large),
              ),
              ChoiceChip(
                label: const Text('Mid Cap (\$1B - \$10B)'),
                selected: _capFilter == MarketCapFilter.mid,
                onSelected: (_) =>
                    setState(() => _capFilter = MarketCapFilter.mid),
              ),
              ChoiceChip(
                label: const Text('Small Cap (<\$1B)'),
                selected: _capFilter == MarketCapFilter.small,
                onSelected: (_) =>
                    setState(() => _capFilter = MarketCapFilter.small),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'MARKET RANK',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All Ranks'),
                selected: _rankFilter == RankFilter.all,
                onSelected: (_) => setState(() => _rankFilter = RankFilter.all),
              ),
              ChoiceChip(
                label: const Text('Top 10'),
                selected: _rankFilter == RankFilter.top10,
                onSelected: (_) =>
                    setState(() => _rankFilter = RankFilter.top10),
              ),
              ChoiceChip(
                label: const Text('Top 50'),
                selected: _rankFilter == RankFilter.top50,
                onSelected: (_) =>
                    setState(() => _rankFilter = RankFilter.top50),
              ),
              ChoiceChip(
                label: const Text('Top 100'),
                selected: _rankFilter == RankFilter.top100,
                onSelected: (_) =>
                    setState(() => _rankFilter = RankFilter.top100),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onReset();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Reset Filters'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onApply(
                      priceFilter: _priceFilter,
                      capFilter: _capFilter,
                      rankFilter: _rankFilter,
                    );
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 12),
        ],
      ),
    );
  }
}
