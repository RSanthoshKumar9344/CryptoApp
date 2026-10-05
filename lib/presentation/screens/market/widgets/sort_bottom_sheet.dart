import 'package:flutter/material.dart';

import '../../../bloc/market/market_state.dart';

class SortBottomSheet extends StatelessWidget {
  final SortField currentField;
  final SortOrder currentOrder;
  final Function(SortField field, SortOrder order) onApply;

  const SortBottomSheet({
    super.key,
    required this.currentField,
    required this.currentOrder,
    required this.onApply,
  });

  static void show(
    BuildContext context, {
    required SortField currentField,
    required SortOrder currentOrder,
    required Function(SortField field, SortOrder order) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SortBottomSheet(
        currentField: currentField,
        currentOrder: currentOrder,
        onApply: onApply,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        SortField selectedField = currentField;
        SortOrder selectedOrder = currentOrder;

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
                    'Sort Cryptocurrencies',
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
                'SORT BY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              _buildFieldTile(
                context: context,
                title: 'Market Cap Rank',
                subtitle: 'Rank #1, #2, #3...',
                icon: Icons.format_list_numbered_rounded,
                field: SortField.rank,
                selectedField: selectedField,
                onSelect: (f) => setState(() => selectedField = f),
              ),
              _buildFieldTile(
                context: context,
                title: 'Market Cap',
                subtitle: 'Total valuation of circulating supply',
                icon: Icons.pie_chart_outline_rounded,
                field: SortField.marketCap,
                selectedField: selectedField,
                onSelect: (f) => setState(() => selectedField = f),
              ),
              _buildFieldTile(
                context: context,
                title: 'Current Price',
                subtitle: 'Unit cost per coin',
                icon: Icons.attach_money_rounded,
                field: SortField.price,
                selectedField: selectedField,
                onSelect: (f) => setState(() => selectedField = f),
              ),
              _buildFieldTile(
                context: context,
                title: '24h Price Change',
                subtitle: '24-hour performance percentage',
                icon: Icons.show_chart_rounded,
                field: SortField.change24h,
                selectedField: selectedField,
                onSelect: (f) => setState(() => selectedField = f),
              ),
              _buildFieldTile(
                context: context,
                title: '24h Trading Volume',
                subtitle: 'Total traded volume in 24 hours',
                icon: Icons.bar_chart_rounded,
                field: SortField.volume,
                selectedField: selectedField,
                onSelect: (f) => setState(() => selectedField = f),
              ),
              const SizedBox(height: 16),
              const Text(
                'ORDER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Ascending')),
                      selected: selectedOrder == SortOrder.ascending,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => selectedOrder = SortOrder.ascending);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Descending')),
                      selected: selectedOrder == SortOrder.descending,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => selectedOrder = SortOrder.descending);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    onApply(selectedField, selectedOrder);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Sorting',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required SortField field,
    required SortField selectedField,
    required ValueChanged<SortField> onSelect,
  }) {
    final theme = Theme.of(context);
    final isSelected = field == selectedField;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
            : const Icon(Icons.circle_outlined, color: Colors.grey),
        onTap: () => onSelect(field),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
