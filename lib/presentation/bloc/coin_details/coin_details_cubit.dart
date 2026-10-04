import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/crypto_repository.dart';
import '../../../data/models/chart_point.dart';
import 'coin_details_state.dart';

class CoinDetailsCubit extends Cubit<CoinDetailsState> {
  final CryptoRepository repository;

  CoinDetailsCubit(this.repository) : super(const CoinDetailsState());

  Future<void> loadCoinDetails(String coinId, {String period = '1D'}) async {
    emit(
      state.copyWith(status: CoinDetailsStatus.loading, selectedPeriod: period),
    );
    try {
      final details = await repository.getCoinDetails(coinId);
      final chartPoints = await repository.getChartData(coinId, period);

      emit(
        state.copyWith(
          status: CoinDetailsStatus.loaded,
          details: details,
          chartData: chartPoints,
          selectedPeriod: period,
          clearSelectedPoint: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CoinDetailsStatus.error,
          errorMessage: 'Failed to load details for $coinId.',
        ),
      );
    }
  }

  Future<void> changePeriod(String coinId, String period) async {
    if (state.selectedPeriod == period && state.chartData.isNotEmpty) return;

    emit(state.copyWith(selectedPeriod: period, clearSelectedPoint: true));
    try {
      final chartPoints = await repository.getChartData(coinId, period);
      emit(state.copyWith(chartData: chartPoints));
    } catch (_) {}
  }

  void selectChartPoint(ChartPoint? point) {
    emit(
      state.copyWith(
        selectedChartPoint: point,
        clearSelectedPoint: point == null,
      ),
    );
  }
}
