import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';

class ResidentHomeTemplate extends StatelessWidget {
  final List<Widget> menuItems;
  final Widget? header;
  final Widget? background;
  final Future<void> Function() onRefresh;
  final Function(int oldIndex, int newIndex) onReorder;

  const ResidentHomeTemplate({
    super.key,
    required this.menuItems,
    required this.onRefresh,
    required this.onReorder,
    this.header,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navyDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Beyond Space',
          style: TextStyle(
            fontFamily: 'Paperlogy',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.textLow,
            letterSpacing: 1.2.w,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, size: 20.sp, color: AppTheme.textLow),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, size: 20.sp, color: AppTheme.textLow),
            onPressed: () {},
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: Stack(
        children: [
          if (background != null) background!,
          RefreshIndicator(
            onRefresh: onRefresh,
            color: AppTheme.accentMint,
            backgroundColor: AppTheme.navyMedium,
            edgeOffset: 100,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24.w, 100.h, 24.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header ?? const SizedBox.shrink(),
                  SizedBox(height: 24.h),
                  ReorderableGridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: menuItems.length,
                    onReorder: onReorder,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return ReorderableDelayedDragStartListener(
                        key: item.key!,
                        index: index,
                        child: item,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
