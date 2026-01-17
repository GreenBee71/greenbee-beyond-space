import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';

class AdminShellTemplate extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final VoidCallback onLogout;

  const AdminShellTemplate({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        toolbarHeight: 0, // Collapsed AppBar since actions are moved
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Row(
        children: [
          // Custom Boxy Sidebar
          Container(
            width: 320.w,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Section
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Paperlogy',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5.w,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Green',
                          style: TextStyle(color: Color(0xFF00E676)), // 녹색
                        ),
                        const TextSpan(
                          text: 'Bee',
                          style: TextStyle(color: Color(0xFFFFD600)), // 노랑색
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: 'Beyond Space',
                          style: TextStyle(
                            color: Color(0xFFFF00FF), // 자홍색 (Magenta)
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Menu Items
                _SidebarBoxItem(
                  icon: Icons.dashboard_customize_rounded,
                  label: '운영 대시보드',
                  isSelected: selectedIndex == 0,
                  onTap: () => onDestinationSelected(0),
                ),
                SizedBox(height: 12.h),
                _SidebarBoxItem(
                  icon: Icons.admin_panel_settings_rounded,
                  label: '방문 차량 현황',
                  isSelected: selectedIndex == 1,
                  onTap: () => onDestinationSelected(1),
                ),
                SizedBox(height: 12.h),
                _SidebarBoxItem(
                  icon: Icons.supervised_user_circle_rounded,
                  label: '입주민 관리 센터',
                  isSelected: selectedIndex == 2,
                  onTap: () => onDestinationSelected(2),
                ),
                SizedBox(height: 12.h),
                _SidebarBoxItem(
                  icon: Icons.settings_suggest_rounded,
                  label: '시스템 설정',
                  isSelected: selectedIndex == 3,
                  onTap: () => onDestinationSelected(3),
                ),
                
                const Spacer(),
                
                // System Logout Button (Moved here)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppTheme.alertRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppTheme.alertRed.withOpacity(0.3), width: 1.w),
                  ),
                  child: TextButton.icon(
                    onPressed: onLogout,
                    icon: Icon(Icons.logout_rounded, size: 28.sp, color: AppTheme.alertRed),
                    label: Text(
                      '시스템 종료',
                      style: TextStyle(
                        fontFamily: 'Paperlogy',
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.alertRed,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                  ),
                ),

                // Sidebar Footer (Version Info, etc.)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center( // Center align version info
                    child: Text(
                      'Ver 1.0.4 Premium',
                      style: TextStyle(
                        fontFamily: 'Paperlogy',
                        color: AppTheme.textLow.withOpacity(0.3),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          VerticalDivider(thickness: 0.5.w, width: 0.5.w, color: AppTheme.glassBorder),
          
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _SidebarBoxItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarBoxItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarBoxItem> createState() => _SidebarBoxItemState();
}

class _SidebarBoxItemState extends State<_SidebarBoxItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.accentMint.withOpacity(0.1)
                : _isHovered
                    ? Colors.white.withOpacity(0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: widget.isSelected
                  ? AppTheme.accentMint.withOpacity(0.3)
                  : _isHovered
                      ? AppTheme.glassBorder
                      : Colors.transparent,
              width: 1.w,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.accentMint.withOpacity(0.05),
                      blurRadius: 15.r,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 32.sp,
                color: widget.isSelected ? AppTheme.accentMint : AppTheme.textLow,
              ),
              SizedBox(width: 16.w),
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Paperlogy',
                  fontSize: 28.sp,
                  fontWeight: widget.isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: widget.isSelected ? AppTheme.textHigh : AppTheme.textMedium,
                ),
              ),
              if (widget.isSelected) ...[
                const Spacer(),
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: const BoxDecoration(
                    color: AppTheme.accentMint,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
