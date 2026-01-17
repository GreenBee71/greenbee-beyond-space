import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_theme.dart';
import 'package:greenbee_web/core/utils/format_utils.dart';

class MasterIoTMonitoringSection extends StatelessWidget {
  final Map<String, dynamic> iotStats;

  const MasterIoTMonitoringSection({super.key, required this.iotStats});

  @override
  Widget build(BuildContext context) {
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
            children: [
              Icon(Icons.sensors_rounded, color: AppTheme.accentMint, size: 28.sp),
              SizedBox(width: 16.w),
              Text(
                'Global IoT System Monitoring',
                style: TextStyle(
                  fontFamily: 'Paperlogy',
                  color: AppTheme.textHigh,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _StatusBadge(trend: iotStats['trend'] ?? 'Stable'),
            ],
          ),
          SizedBox(height: 32.h),
          Row(
            children: [
              _IoTStatItem(
                label: 'Connected Devices',
                value: FormatUtils.formatNumber(iotStats['total_connected_devices'] ?? 0),
                subLabel: 'Across all complexes',
              ),
              _VerticalDivider(),
              _IoTStatItem(
                label: 'Active Hubs',
                value: '2,481', // Mock or calculated
                subLabel: '99.9% Online',
              ),
              _VerticalDivider(),
              _IoTStatItem(
                label: 'Data Packets / sec',
                value: '142.5k',
                subLabel: 'Real-time throughput',
              ),
            ],
          ),
          SizedBox(height: 32.h),
          // Simple visualization placeholder
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Center(
              child: Text(
                'IoT Mesh Network Topology Visualization (Live Feed)',
                style: TextStyle(
                  fontFamily: 'Paperlogy',
                  color: AppTheme.textLow.withOpacity(0.5),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IoTStatItem extends StatelessWidget {
  final String label;
  final String value;
  final String subLabel;

  const _IoTStatItem({required this.label, required this.value, required this.subLabel});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 13.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Paperlogy',
              color: AppTheme.textHigh,
              fontSize: 28.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subLabel,
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint.withOpacity(0.7), fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5.w,
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      color: Colors.white10,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String trend;
  const _StatusBadge({required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppTheme.accentMint.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppTheme.accentMint.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(color: AppTheme.accentMint, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Text(
            trend,
            style: TextStyle(
              fontFamily: 'Paperlogy',
              color: AppTheme.accentMint,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
