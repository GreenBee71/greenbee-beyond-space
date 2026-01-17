import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_theme.dart';

class AnnouncementListItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const AnnouncementListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  item['target_complex'] ?? 'ALL',
                  style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.primaryGreen, fontSize: 10.sp, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                item['created_at']?.split('T')[0] ?? '',
                style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white38, fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            item['title'] ?? 'No Title',
            style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          Text(
            item['content'] ?? '',
            style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white.withOpacity(0.7), fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
