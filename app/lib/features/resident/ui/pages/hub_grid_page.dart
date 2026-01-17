import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../templates/resident_home_template.dart';

class HubGridPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Widget> menuItems;

  const HubGridPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return ResidentHomeTemplate(
      header: _buildHeader(),
      onRefresh: () async {},
      onReorder: (oldIndex, newIndex) {}, // Hubs are usually fixed for now or can be orderable later
      menuItems: menuItems,
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFFFD700), size: 34.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: -0.5.w,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFFFD700).withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
