import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';
import 'package:greenbee_web/core/widgets/atoms/glass_container.dart';

class TransactionTile extends StatelessWidget {
  final String description;
  final String type;
  final double amount;
  final DateTime createdAt;

  const TransactionTile({
    super.key,
    required this.description,
    required this.type,
    required this.amount,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = amount < 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
      child: GlassContainer(
        padding: EdgeInsets.all(16.r),
        borderRadius: BorderRadius.circular(16.r),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: (isNegative ? AppTheme.alertRed : AppTheme.accentMint).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNegative ? Icons.remove_circle_outline : Icons.add_circle_outline,
                color: isNegative ? AppTheme.alertRed : AppTheme.accentMint,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description, 
                    style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 16.sp, fontWeight: FontWeight.w500)
                  ),
                  Text(
                    DateFormat('yyyy.MM.dd HH:mm').format(createdAt),
                    style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            Text(
              '${isNegative ? "" : "+"}${NumberFormat('#,###').format(amount)}',
              style: TextStyle(fontFamily: 'Paperlogy', 
                color: isNegative ? Colors.white : AppTheme.accentMint,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                letterSpacing: -0.2.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
