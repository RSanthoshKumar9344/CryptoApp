import 'package:equatable/equatable.dart';

import '../../../data/models/coin_details.dart';
import '../../../data/models/chart_point.dart';

enum CoinDetailsStatus { initial, loading, loaded, error }

class CoinDetailsState extends Equatable {
  final CoinDetailsStatus status;
  final CoinDetails? details;
  final List<ChartPoint> chartData;
  final String selectedPeriod;
  final ChartPoint? selectedChartPoint;
  final String? errorMessage;

  const CoinDetailsState({
    this.status = CoinDetailsStatus.initial,
    this.details,
    this.chartData = const [],
    this.selectedPeriod = '1D',
    this.selectedChartPoint,
    this.errorMessage,
  });

  CoinDetailsState copyWith({
    CoinDetailsStatus? status,
    CoinDetails? details,
    List<ChartPoint>? chartData,
    String? selectedPeriod,
    ChartPoint? selectedChartPoint,
    bool clearSelectedPoint = false,
    String? errorMessage,
  }) {
    return CoinDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      chartData: chartData ?? this.chartData,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedChartPoint: clearSelectedPoint
          ? null
          : (selectedChartPoint ?? this.selectedChartPoint),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    details,
    chartData,
    selectedPeriod,
    selectedChartPoint,
    errorMessage,
  ];
}
