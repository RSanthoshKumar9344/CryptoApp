import 'package:flutter/material.dart';

class CryptoLogo extends StatelessWidget {
  final String symbol;
  final String? imageUrl;
  final double size;

  const CryptoLogo({
    super.key,
    required this.symbol,
    this.imageUrl,
    this.size = 40,
  });

  Color _getBadgeColor(String sym) {
    switch (sym.toUpperCase()) {
      case 'BTC':
        return const Color(0xFFF7931A);
      case 'ETH':
        return const Color(0xFF627EEA);
      case 'USDT':
        return const Color(0xFF26A17B);
      case 'BNB':
        return const Color(0xFFF3BA2F);
      case 'SOL':
        return const Color(0xFF14F195);
      case 'XRP':
        return const Color(0xFF23292F);
      case 'USDC':
        return const Color(0xFF2775CA);
      case 'ADA':
        return const Color(0xFF0033AD);
      case 'AVAX':
        return const Color(0xFFE84142);
      case 'DOGE':
        return const Color(0xFFC2A633);
      case 'LINK':
        return const Color(0xFF375BD2);
      case 'DOT':
        return const Color(0xFFE6007A);
      case 'MATIC':
      case 'POL':
        return const Color(0xFF8247E5);
      case 'LTC':
        return const Color(0xFF345D9D);
      case 'SHIB':
        return const Color(0xFFFFA409);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getBadgeColor(symbol);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Center(
        child: Text(
          symbol.length > 3
              ? symbol.substring(0, 3).toUpperCase()
              : symbol.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.36,
          ),
        ),
      ),
    );
  }
}
