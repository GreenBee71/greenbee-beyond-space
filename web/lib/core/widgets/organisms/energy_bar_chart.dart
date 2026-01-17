import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/energy_usage.dart';
import '../../theme/app_theme.dart';

class EnergyBarChart extends StatelessWidget {
  final List<EnergyUsage> history;

  const EnergyBarChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const Center(child: Text('데이터 없음'));

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: history.map((e) => e.electricity.toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  final date = DateTime.parse(history[value.toInt()].usageMonth);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('${date.month}월', style: const TextStyle(fontFamily: 'Paperlogy', fontSize: 12, color: AppTheme.textMedium)),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: history.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.electricity.toDouble(),
                color: AppTheme.neonGreen,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
