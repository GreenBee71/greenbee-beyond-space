import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_theme.dart';

class AdminUserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback? onVerify;

  const AdminUserCard({
    super.key,
    required this.user,
    this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.r),
        leading: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.1),
          child: Icon(Icons.person, color: AppTheme.textMedium, size: 24.sp),
        ),
        title: Text(
          '${user['full_name'] ?? 'No Name'} (${user['dong']}-${user['ho']})',
          style: TextStyle(fontFamily: 'Paperlogy', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.sp),
        ),
        subtitle: Text(
          'Complex: ${user['complex_name']}\nEmail: ${user['email']}',
          style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white.withOpacity(0.7), fontSize: 13.sp),
        ),
        trailing: onVerify != null 
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              onPressed: onVerify,
              child: Text('Verify', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 14.sp, fontWeight: FontWeight.w500)),
            )
          : null,
      ),
    );
  }
}
