import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_theme.dart';
import 'package:greenbee_web/core/utils/format_utils.dart';

class ComplexListItem extends StatelessWidget {
  final Map<String, dynamic> complex;
  final VoidCallback? onDelete;

  const ComplexListItem({super.key, required this.complex, this.onDelete});

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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.apartment, color: AppTheme.primaryGreen, size: 24.sp),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complex['name'],
                  style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Admin: ${complex['admin_name']}',
                  style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white.withOpacity(0.6), fontSize: 14.sp),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${FormatUtils.formatNumber(complex['total_members'] ?? 0)} members',
                style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.accentMint.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'ACTIVE',
                  style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontSize: 10.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20.sp),
            onPressed: () => _onDelete(context),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.chevron_right, color: Colors.white24, size: 24.sp),
        ],
      ),
    );
  }

  void _onDelete(BuildContext context) {
    if (onDelete != null) {
      onDelete!();
    }
  }
}
