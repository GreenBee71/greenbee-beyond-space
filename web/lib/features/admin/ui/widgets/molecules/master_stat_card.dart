import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';
import 'package:greenbee_web/core/widgets/atoms/glass_container.dart';

class MasterStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  const MasterStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: (color ?? AppTheme.accentMint).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color ?? AppTheme.accentMint, size: 24.sp), // Increased from 20.sp
              ),
              Icon(Icons.more_vert, color: AppTheme.textLow, size: 16.sp),
            ],
          ),
          const Spacer(),
            Text(
            title, 
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 16.sp, fontWeight: FontWeight.w400)
          ),
          SizedBox(height: 6.h),
          FittedBox(
            child: Text(
              value, 
              style: TextStyle(fontFamily: 'Paperlogy', 
                color: AppTheme.textHigh, 
                fontSize: 32.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5.w,
              )
            ),
          ),
        ],
      ),
    );
  }
}
