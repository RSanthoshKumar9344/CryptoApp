import 'package:equatable/equatable.dart';

class ChartPoint extends Equatable {
  final DateTime timestamp;
  final double price;

  const ChartPoint({required this.timestamp, required this.price});

  Map<String, dynamic> toJson() {
    return {'timestamp': timestamp.toIso8601String(), 'price': price};
  }

  factory ChartPoint.fromJson(Map<String, dynamic> json) {
    final rawTime = json['timestamp'] ?? json['time'];
    DateTime parsedTime;
    if (rawTime is String) {
      parsedTime = DateTime.parse(rawTime);
    } else if (rawTime is int) {
      parsedTime = DateTime.fromMillisecondsSinceEpoch(rawTime);
    } else {
      parsedTime = DateTime.now();
    }

    final rawPrice = json['price'] ?? json['y'] ?? 0.0;

    return ChartPoint(
      timestamp: parsedTime,
      price: (rawPrice as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [timestamp, price];
}
