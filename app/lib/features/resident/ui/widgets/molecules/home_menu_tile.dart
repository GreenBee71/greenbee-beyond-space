import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class HomeMenuTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const HomeMenuTile({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: GlassContainer(
        padding: EdgeInsets.all(20.w),
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white,
        opacity: 0.03,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.accentMint).withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: (iconColor ?? AppTheme.accentMint).withOpacity(0.2),
                  width: 0.5.w,
                ),
              ),
              child: Icon(
                icon,
                size: 28.sp,
                color: iconColor ?? AppTheme.accentMint,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Paperlogy',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.textHigh,
                letterSpacing: -0.2.w,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
