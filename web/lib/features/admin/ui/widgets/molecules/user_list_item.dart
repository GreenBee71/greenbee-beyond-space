import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_theme.dart';

class UserListItem extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function(String)? onRoleChange;

  const UserListItem({super.key, required this.user, this.onRoleChange});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> apps = user['apartments'] ?? [];
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
            child: Text(
              user['full_name']?[0] ?? '?',
              style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.primaryGreen, fontWeight: FontWeight.w500, fontSize: 16.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['full_name'] ?? 'Unknown User',
                  style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                Text(
                  user['email'],
                  style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white.withOpacity(0.6), fontSize: 13.sp),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               if (apps.isEmpty)
                Text('No Complex', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white38, fontSize: 12.sp))
              else
                ...apps.take(1).map((a) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getRoleColor(a['role']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    a['complex_name'],
                    style: TextStyle(fontFamily: 'Paperlogy', color: _getRoleColor(a['role']), fontSize: 11.sp, fontWeight: FontWeight.w500),
                  ),
                )),
              SizedBox(height: 4.h),
              Text(
                user['is_verified'] ? 'VERIFIED' : 'PENDING',
                style: TextStyle(fontFamily: 'Paperlogy', 
                  color: user['is_verified'] ? AppTheme.primaryGreen : Colors.orange,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: user['global_role'] == 'MASTER_ADMIN' ? Colors.purple.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: user['global_role'] == 'MASTER_ADMIN' ? Colors.purpleAccent.withOpacity(0.3) : Colors.white10),
                ),
                child: Text(
                  user['global_role'] ?? 'USER',
                  style: TextStyle(fontFamily: 'Paperlogy', 
                    color: user['global_role'] == 'MASTER_ADMIN' ? Colors.purpleAccent : AppTheme.textLow,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.more_vert, color: AppTheme.textLow, size: 20.sp),
                onPressed: () => _showActionMenu(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.navyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.shield_outlined, color: Colors.white, size: 24.sp),
              title: Text(
                user['global_role'] == 'MASTER_ADMIN' ? 'Revoke Master Admin' : 'Make Master Admin',
                style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 15.sp)
              ),
              onTap: () {
                Navigator.pop(context);
                if (onRoleChange != null) {
                  onRoleChange!(user['global_role'] == 'MASTER_ADMIN' ? 'USER' : 'MASTER_ADMIN');
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.close, color: AppTheme.textLow, size: 24.sp),
              title: Text('Cancel', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 15.sp)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'ADMIN': return Colors.purpleAccent;
      case 'OWNER': return Colors.blueAccent;
      default: return AppTheme.textMedium;
    }
  }
}
