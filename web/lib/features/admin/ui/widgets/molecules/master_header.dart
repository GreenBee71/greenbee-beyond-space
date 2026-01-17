import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';

class MasterHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onRefresh;

  const MasterHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontFamily: 'Paperlogy', 
                color: AppTheme.textHigh,
                fontSize: 32.sp, // Standardized
                fontWeight: FontWeight.w500,
                letterSpacing: -1.0.w,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyle(fontFamily: 'Paperlogy', 
                color: AppTheme.textLow,
                fontSize: 24.sp, // Increased to 24.sp
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppTheme.glassBorder, width: 0.5.w),
          ),
          child: IconButton(
            icon: Icon(Icons.refresh_rounded, color: AppTheme.textMedium, size: 24.sp), // Increased from 20.sp
            onPressed: onRefresh,
            hoverColor: AppTheme.accentMint.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}
