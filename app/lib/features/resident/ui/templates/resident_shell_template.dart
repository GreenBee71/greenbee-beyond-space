import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';

class ResidentShellTemplate extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const ResidentShellTemplate({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppTheme.glassBorder,
              width: 0.5.w,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20.r,
              offset: Offset(0, -4.h),
            ),
          ],
        ),
        child: ClipRRect(
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onDestinationSelected,
            backgroundColor: AppTheme.voidBlack.withOpacity(0.95),
            selectedItemColor: AppTheme.accentMint,
            unselectedItemColor: AppTheme.textLow.withOpacity(0.5),
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontFamily: 'Paperlogy',
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              letterSpacing: -0.2.w,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Paperlogy',
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              letterSpacing: -0.2.w,
            ),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24.sp),
                activeIcon: Icon(Icons.home_rounded, size: 24.sp, color: AppTheme.accentMint),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined, size: 24.sp),
                activeIcon: Icon(Icons.explore_rounded, size: 24.sp, color: AppTheme.accentMint),
                label: 'Beyond',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.headset_mic_outlined, size: 24.sp),
                activeIcon: Icon(Icons.headset_mic_rounded, size: 24.sp, color: AppTheme.accentMint),
                label: 'Support',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.hub_outlined, size: 24.sp),
                activeIcon: Icon(Icons.hub_rounded, size: 24.sp, color: AppTheme.accentMint),
                label: 'Connect',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner_outlined, size: 24.sp),
                activeIcon: Icon(Icons.qr_code_scanner_rounded, size: 24.sp, color: AppTheme.accentMint),
                label: 'Pass',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
