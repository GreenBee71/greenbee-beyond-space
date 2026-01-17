import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';
import 'package:greenbee_web/core/models/visitor.dart';

class AdminVisitorCard extends StatelessWidget {
  final Visitor visitor;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const AdminVisitorCard({
    super.key,
    required this.visitor,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = visitor.status == 'PENDING';

    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.r),
        title: Text(
          '${visitor.carNumber} (${visitor.visitorName})',
          style: TextStyle(fontFamily: 'Paperlogy', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text('Purpose: ${visitor.purpose}', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white.withOpacity(0.7), fontSize: 13.sp)),
            Text('Date: ${visitor.visitDate.toString().split(' ')[0]}',
                style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white.withOpacity(0.7), fontSize: 13.sp)),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _getStatusColor(visitor.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: _getStatusColor(visitor.status).withOpacity(0.5)),
              ),
              child: Text(
                visitor.status,
                style: TextStyle(fontFamily: 'Paperlogy', color: _getStatusColor(visitor.status), fontSize: 12.sp),
              ),
            ),
          ],
        ),
        trailing: isPending
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check_circle_outline, color: AppTheme.accentMint, size: 24.sp),
                    onPressed: onApprove,
                  ),
                  IconButton(
                    icon: Icon(Icons.highlight_off, color: Colors.redAccent, size: 24.sp),
                    onPressed: onReject,
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return AppTheme.accentMint;
      case 'REJECTED':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }
}
