import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/crypto_repository.dart';
import '../../../data/models/coin.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final CryptoRepository repository;

  StatisticsCubit(this.repository) : super(const StatisticsState());

  Future<void> loadStatistics() async {
    emit(state.copyWith(status: StatisticsStatus.loading));
    try {
      final stats = await repository.getMarketStatistics();
      final coins = await repository.getCoins();

      // Top Gainers
      final gainers = List<Coin>.from(coins)
        ..sort(
          (a, b) =>
              b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h),
        );

      // Top Losers
      final losers = List<Coin>.from(coins)
        ..sort(
          (a, b) =>
              a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h),
        );

      // Top Volume
      final volume = List<Coin>.from(coins)
        ..sort((a, b) => b.totalVolume.compareTo(a.totalVolume));

      emit(
        state.copyWith(
          status: StatisticsStatus.loaded,
          marketStatistics: stats,
          topGainers: gainers.take(5).toList(),
          topLosers: losers.take(5).toList(),
          topVolume: volume.take(5).toList(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: StatisticsStatus.error));
    }
  }
}
