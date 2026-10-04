import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/currency_formatter.dart';

class PriceChangeChip extends StatelessWidget {
  final double priceChangePercentage;
  final bool compact;

  const PriceChangeChip({
    super.key,
    required this.priceChangePercentage,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = priceChangePercentage >= 0;
    final color = isPositive ? AppColors.positive : AppColors.negative;
    final backgroundColor = isPositive
        ? AppColors.positiveBackground
        : AppColors.negativeBackground;
    final icon = isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          Text(
            CurrencyFormatter.formatPercentage(priceChangePercentage),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 2),
          Text(
            CurrencyFormatter.formatPercentage(priceChangePercentage),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
