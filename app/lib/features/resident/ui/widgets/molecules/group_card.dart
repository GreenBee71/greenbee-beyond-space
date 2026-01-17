import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final List<IconData> icons;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const GroupCard({
    super.key,
    required this.title,
    required this.icons,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(24.r),
      child: GlassContainer(
        padding: EdgeInsets.all(16.w),
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white,
        opacity: 0.05,
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
                children: icons.take(4).map((icon) => Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16.sp, color: AppTheme.accentMint.withOpacity(0.7)),
                )).toList(),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Paperlogy',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.textHigh,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
