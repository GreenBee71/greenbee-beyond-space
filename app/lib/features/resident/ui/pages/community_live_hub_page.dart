import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/living_provider.dart';

class CommunityLiveHubPage extends ConsumerWidget {
  const CommunityLiveHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilitiesAsync = ref.watch(facilitiesProvider);

    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        title: const Text('커뮤니티', style: TextStyle(fontFamily: 'Paperlogy')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: facilitiesAsync.when(
        data: (facilities) {
          if (facilities.isEmpty) {
             return const Center(child: Text('운영 중인 시설이 없습니다.', style: TextStyle(color: Colors.white)));
          }
          return GridView.builder(
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: facilities.length,
            itemBuilder: (context, index) {
              final facility = facilities[index];
              return _buildFacilityCard(facility);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentMint)),
        error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildFacilityCard(Map<String, dynamic> facility) {
    bool isOpen = facility['is_open'] ?? false;
    int current = facility['current_users'] ?? 0;
    int capacity = facility['capacity'] ?? 100;
    double occupancy = current / capacity;

    Color statusColor = isOpen ? AppTheme.accentMint : Colors.grey;
    String statusText = isOpen ? '운영 중' : '종료';
    
    String congestion = '여유';
    Color congestionColor = Colors.green;
    if (occupancy > 0.8) {
      congestion = '혼잡';
      congestionColor = Colors.red;
    } else if (occupancy > 0.5) {
      congestion = '보통';
      congestionColor = Colors.orange;
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
              Icon(Icons.house_siding_rounded, color: statusColor, size: 24.sp),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  statusText, 
                  style: TextStyle(
                    fontFamily: 'Paperlogy', 
                    color: statusColor, 
                    fontWeight: FontWeight.w500, 
                    fontSize: 12.sp
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            facility['name'] ?? 'Facility',
            style: TextStyle(
              fontFamily: 'Paperlogy', 
              fontSize: 14.sp, 
              fontWeight: FontWeight.w500, 
              color: AppTheme.textHigh
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(
                 '$current / $capacity 명',
                 style: TextStyle(
                   fontFamily: 'Paperlogy', 
                   color: AppTheme.textLow, 
                   fontSize: 12.sp
                 ),
               ),
               Text(
                 congestion,
                 style: TextStyle(
                   fontFamily: 'Paperlogy', 
                   color: congestionColor, 
                   fontSize: 12.sp,
                   fontWeight: FontWeight.w500
                 ),
               ),
             ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(2.r),
            child: LinearProgressIndicator(
              value: occupancy,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: AlwaysStoppedAnimation<Color>(congestionColor),
              minHeight: 4.h,
            ),
          ),
        ],
      ),
    );
  }
}
