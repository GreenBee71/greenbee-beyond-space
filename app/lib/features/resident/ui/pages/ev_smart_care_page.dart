import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/living_provider.dart';

class EVSmartCarePage extends ConsumerWidget {
  const EVSmartCarePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evAsync = ref.watch(evChargersProvider);

    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        title: const Text('전기차 충전', style: TextStyle(fontFamily: 'Paperlogy')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: evAsync.when(
        data: (chargers) {
          if (chargers.isEmpty) {
            return _buildEmptyState();
          }
          return GridView.builder(
            padding: EdgeInsets.all(24.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.9,
            ),
            itemCount: chargers.length,
            itemBuilder: (context, index) {
              final charger = chargers[index];
              return _buildChargerCard(charger);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentMint)),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildChargerCard(Map<String, dynamic> charger) {
    String status = charger['status'] ?? 'UNKNOWN';
    Color statusColor;
    String statusText;

    switch (status) {
      case 'AVAILABLE':
        statusColor = const Color(0xFF00FF88);
        statusText = '사용 가능';
        break;
      case 'CHARGING':
      case 'OCCUPIED':
        statusColor = Colors.redAccent;
        statusText = '충전 중';
        break;
      default:
        statusColor = Colors.grey;
        statusText = '점검 중';
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.ev_station_rounded, color: statusColor, size: 24.sp),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontFamily: 'Paperlogy',
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            charger['location'] ?? 'Unknown Location',
            style: TextStyle(
              fontFamily: 'Paperlogy',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textHigh,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            'ID: ${charger['charger_id'] ?? '-'}',
            style: TextStyle(
              fontFamily: 'Paperlogy',
              fontSize: 12.sp,
              color: AppTheme.textLow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        '등록된 충전소가 없습니다.',
        style: TextStyle(
          fontFamily: 'Paperlogy',
          color: Colors.white,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
