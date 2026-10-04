import 'package:intl/intl.dart';

abstract class CurrencyFormatter {
  static String formatCurrency(double price, {int decimalDigits = 2}) {
    if (price < 0.01 && price > 0) {
      return '\$${price.toStringAsFixed(6)}';
    } else if (price < 1.0) {
      return '\$${price.toStringAsFixed(4)}';
    }
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: decimalDigits,
    );
    return formatter.format(price);
  }

  static String formatCompactCurrency(double amount) {
    if (amount >= 1e12) {
      return '\$${(amount / 1e12).toStringAsFixed(2)}T';
    } else if (amount >= 1e9) {
      return '\$${(amount / 1e9).toStringAsFixed(2)}B';
    } else if (amount >= 1e6) {
      return '\$${(amount / 1e6).toStringAsFixed(2)}M';
    } else if (amount >= 1e3) {
      return '\$${(amount / 1e3).toStringAsFixed(2)}K';
    }
    return '\$${amount.toStringAsFixed(2)}';
  }

  static String formatCompactNumber(double amount, {String symbol = ''}) {
    String formatted;
    if (amount >= 1e12) {
      formatted = '${(amount / 1e12).toStringAsFixed(2)}T';
    } else if (amount >= 1e9) {
      formatted = '${(amount / 1e9).toStringAsFixed(2)}B';
    } else if (amount >= 1e6) {
      formatted = '${(amount / 1e6).toStringAsFixed(2)}M';
    } else if (amount >= 1e3) {
      formatted = '${(amount / 1e3).toStringAsFixed(2)}K';
    } else {
      formatted = amount.toStringAsFixed(0);
    }

    if (symbol.isNotEmpty) {
      return '$formatted $symbol';
    }
    return formatted;
  }

  static String formatPercentage(double percent) {
    final prefix = percent >= 0 ? '+' : '';
    return '$prefix${percent.toStringAsFixed(2)}%';
  }
}
