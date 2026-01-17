import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_theme.dart';
import '../atoms/glass_container.dart';

class NavCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const NavCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontFamily: 'Paperlogy', 
                color: AppTheme.textHigh, 
                fontSize: 22.sp, // Increased from 18.sp
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2.w,
              ),
            ),
            if (actionLabel != null && onActionPressed != null)
              TextButton(
                onPressed: onActionPressed,
                child: Text(
                  actionLabel!, 
                  style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontSize: 16.sp, fontWeight: FontWeight.w500) // Increased from 13.sp
                ),
              ),
          ],
        ),
        SizedBox(height: 16.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: GlassContainer(
            padding: EdgeInsets.all(24.r),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: AppTheme.textMedium, size: 28.sp), // Increased from 24.sp
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 16.sp, height: 1.4), // Increased from 14.sp
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppTheme.textLow.withOpacity(0.3), size: 18.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
