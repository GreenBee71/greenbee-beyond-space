import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';

class MasterDashboardTemplate extends StatelessWidget {
  final Widget header;
  final Widget statsGrid;
  final Widget? analyticsSection; // New field
  final Widget? iotSection;
  final Widget actionSection;
  final List<Widget> navigationCards;

  const MasterDashboardTemplate({
    super.key,
    required this.header,
    required this.statsGrid,
    this.analyticsSection,
    this.iotSection,
    required this.actionSection,
    required this.navigationCards,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 64.h),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1400.w), // Relative focus width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                SizedBox(height: 48.h),
                statsGrid,
                if (analyticsSection != null) ...[
                  SizedBox(height: 48.h),
                  analyticsSection!,
                ],
                if (iotSection != null) ...[
                  SizedBox(height: 48.h),
                  iotSection!,
                ],
                SizedBox(height: 64.h),
                actionSection,
                SizedBox(height: 80.h),
                Text(
                  'Quick Management',
                  style: TextStyle(fontFamily: 'Paperlogy', 
                    color: AppTheme.textHigh,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5.w,
                  ),
                ),
                SizedBox(height: 24.h),
                // Grid for navigation cards on desktop
                LayoutBuilder(
                  builder: (context, child) {
                    final width = MediaQuery.of(context).size.width;
                    if (width > 800) {
                      return GridView.count(
                        crossAxisCount: width > 800 ? 4 : (width > 600 ? 2 : 1),
                        crossAxisSpacing: 32.w,
                        mainAxisSpacing: 32.h,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: width > 800 ? 1.25 : 1.6, // Adjusted for 1920 baseline
                        children: navigationCards,
                      );
                    } else {
                      return Column(
                        children: navigationCards.expand((card) => [card, SizedBox(height: 24.h)]).toList(),
                      );
                    }
                  },
                ),
                SizedBox(height: 48.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
