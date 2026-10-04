import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/chart_point.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';

class PriceChart extends StatelessWidget {
  final List<ChartPoint> chartPoints;
  final bool isPositive;
  final Function(ChartPoint?) onSpotSelected;

  const PriceChart({
    super.key,
    required this.chartPoints,
    required this.isPositive,
    required this.onSpotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (chartPoints.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No chart data available')),
      );
    }

    final lineColor = isPositive ? AppColors.positive : AppColors.negative;
    final minPrice = chartPoints
        .map((p) => p.price)
        .reduce((a, b) => a < b ? a : b);
    final maxPrice = chartPoints
        .map((p) => p.price)
        .reduce((a, b) => a > b ? a : b);
    final padding = (maxPrice - minPrice) * 0.1;

    final spots = List.generate(
      chartPoints.length,
      (i) => FlSpot(i.toDouble(), chartPoints[i].price),
    );

    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 12, left: 12, bottom: 8),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (maxPrice - minPrice) / 3 > 0
                  ? (maxPrice - minPrice) / 3
                  : 1,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (chartPoints.length - 1).toDouble(),
            minY: minPrice - padding,
            maxY: maxPrice + padding,
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true,
              touchCallback:
                  (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    if (touchResponse == null ||
                        touchResponse.lineBarSpots == null ||
                        touchResponse.lineBarSpots!.isEmpty) {
                      onSpotSelected(null);
                      return;
                    }
                    final index = touchResponse.lineBarSpots!.first.spotIndex;
                    if (index >= 0 && index < chartPoints.length) {
                      onSpotSelected(chartPoints[index]);
                    }
                  },
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (spot) =>
                    Theme.of(context).colorScheme.surface,
                tooltipBorder: BorderSide(
                  color: lineColor.withValues(alpha: 0.5),
                  width: 1,
                ),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final point = chartPoints[spot.spotIndex];
                    final dateStr = DateFormat('MMM dd, HH:mm')
                        .format(point.timestamp);
                    return LineTooltipItem(
                      '${CurrencyFormatter.formatCurrency(point.price)}\n',
                      TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: dateStr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.25,
                color: lineColor,
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      lineColor.withValues(alpha: 0.25),
                      lineColor.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
