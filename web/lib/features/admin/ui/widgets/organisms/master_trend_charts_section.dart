import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/theme/app_theme.dart';

class MasterTrendChartsSection extends StatelessWidget {
  final Map<String, dynamic> trends;

  const MasterTrendChartsSection({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildEnergyLineChart()),
        SizedBox(width: 32.w),
        Expanded(flex: 1, child: _buildPerformanceBarChart()),
      ],
    );
  }

  Widget _buildEnergyLineChart() {
    final List<dynamic> data = trends['energy_consumption'] ?? [];
    
    return Container(
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.glassBorder, width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Energy Consumption Trend',
                style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppTheme.accentMint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Last 6 Months',
                  style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 48.h),
          SizedBox(
            height: 250.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Text(
                              data[index]['month'],
                              style: TextStyle(color: AppTheme.textLow, fontSize: 11.sp, fontFamily: 'Paperlogy'),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 32,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value/1000).toStringAsFixed(1)}k',
                        style: TextStyle(color: AppTheme.textLow, fontSize: 11.sp, fontFamily: 'Paperlogy'),
                      ),
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value['value'].toDouble())).toList(),
                    isCurved: true,
                    gradient: LinearGradient(colors: [AppTheme.accentMint, AppTheme.accentMint.withOpacity(0.5)]),
                    barWidth: 3.w,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.deepSpace,
                        strokeWidth: 2,
                        strokeColor: AppTheme.accentMint,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentMint.withOpacity(0.2),
                          AppTheme.accentMint.withOpacity(0),
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
        ],
      ),
    );
  }

  Widget _buildPerformanceBarChart() {
    final List<dynamic> perf = trends['complex_performance'] ?? [];

    return Container(
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.glassBorder, width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complex Performance',
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 32.h),
          ...perf.map((item) => Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['name'], style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 14.sp)),
                    Text('${item['score']}%', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 12.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: item['score'] / 100,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    color: item['score'] > 90 ? AppTheme.accentMint : (item['score'] > 70 ? Colors.blueAccent : Colors.orangeAccent),
                    minHeight: 8.h,
                  ),
                ),
              ],
            ),
          )).toList(),
          SizedBox(height: 8.h),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text('View Details', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint.withOpacity(0.7), fontSize: 13.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
