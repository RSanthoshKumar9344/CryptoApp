import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String? imageUrl;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final int marketCapRank;
  final double totalVolume;
  final double circulatingSupply;
  final double? totalSupply;

  const Coin({
    required this.id,
    required this.symbol,
    required this.name,
    this.imageUrl,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.marketCapRank,
    required this.totalVolume,
    required this.circulatingSupply,
    this.totalSupply,
  });

  Coin copyWith({
    String? id,
    String? symbol,
    String? name,
    String? imageUrl,
    double? currentPrice,
    double? priceChangePercentage24h,
    double? marketCap,
    int? marketCapRank,
    double? totalVolume,
    double? circulatingSupply,
    double? totalSupply,
  }) {
    return Coin(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChangePercentage24h:
          priceChangePercentage24h ?? this.priceChangePercentage24h,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      totalVolume: totalVolume ?? this.totalVolume,
      circulatingSupply: circulatingSupply ?? this.circulatingSupply,
      totalSupply: totalSupply ?? this.totalSupply,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'imageUrl': imageUrl,
      'currentPrice': currentPrice,
      'priceChangePercentage24h': priceChangePercentage24h,
      'marketCap': marketCap,
      'marketCapRank': marketCapRank,
      'totalVolume': totalVolume,
      'circulatingSupply': circulatingSupply,
      'totalSupply': totalSupply,
    };
  }

  factory Coin.fromJson(Map<String, dynamic> json) {
    final image = json['imageUrl'] ?? json['image_url'] ?? json['image'];
    final price = json['currentPrice'] ?? json['current_price'] ?? 0.0;
    final change24h =
        json['priceChangePercentage24h'] ??
        json['price_change_percentage_24h'] ??
        0.0;
    final mCap = json['marketCap'] ?? json['market_cap'] ?? 0.0;
    final mRank = json['marketCapRank'] ?? json['market_cap_rank'] ?? 0;
    final volume = json['totalVolume'] ?? json['total_volume'] ?? 0.0;
    final cSupply =
        json['circulatingSupply'] ?? json['circulating_supply'] ?? 0.0;
    final tSupply = json['totalSupply'] ?? json['total_supply'];

    return Coin(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      imageUrl: image as String?,
      currentPrice: (price as num).toDouble(),
      priceChangePercentage24h: (change24h as num).toDouble(),
      marketCap: (mCap as num).toDouble(),
      marketCapRank: (mRank as num).toInt(),
      totalVolume: (volume as num).toDouble(),
      circulatingSupply: (cSupply as num).toDouble(),
      totalSupply: tSupply != null ? (tSupply as num).toDouble() : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    symbol,
    name,
    imageUrl,
    currentPrice,
    priceChangePercentage24h,
    marketCap,
    marketCapRank,
    totalVolume,
    circulatingSupply,
    totalSupply,
  ];
}
