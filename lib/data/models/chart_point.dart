import 'package:equatable/equatable.dart';

class ChartPoint extends Equatable {
  final DateTime timestamp;
  final double price;

  const ChartPoint({required this.timestamp, required this.price});

  @override
  List<Object?> get props => [timestamp, price];
}
