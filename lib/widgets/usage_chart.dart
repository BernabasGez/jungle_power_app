import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/power_data.dart';

class UsageChart extends StatelessWidget {
  final List<PowerSnapshot> data;
  const UsageChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Center(child: Text('No data'));
    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.kW))
        .toList();
    final maxY = data.map((d) => d.kW).reduce((a, b) => a > b ? a : b) * 1.2;
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(show: true, horizontalInterval: maxY / 4),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            dotData: FlDotData(show: false),
            color: Theme.of(context).colorScheme.primary,
            belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }
}
