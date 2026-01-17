import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';

class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard_customize, size: 64.sp, color: Colors.white24),
            SizedBox(height: 16.h),
            Text(
              'Admin Overview',
              style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Text(
              'Select a management section from the sidebar to begin.',
              style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
