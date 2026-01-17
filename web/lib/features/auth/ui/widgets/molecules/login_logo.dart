import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120.r,
          height: 120.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: AppTheme.accentMint.withOpacity(0.3),
              width: 1.w,
            ),
          ),
        ),
        SizedBox(height: 40.h),
        RichText(
          textAlign: TextAlign.center,
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
              const TextSpan(
                text: ' Beyond',
                style: TextStyle(
                  color: Color(0xFFFF00FF), // 자홍색 (Magenta)
                ),
              ),
              const TextSpan(
                text: ' Space',
                style: TextStyle(
                  color: Color(0xFFFF00FF), // 자홍색 (Magenta)
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'MASTER ADMIN PORTAL',
          style: TextStyle(
            fontFamily: 'Paperlogy',
            color: AppTheme.accentMint.withOpacity(0.8),
            fontSize: 20.sp,
            letterSpacing: 2.w,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'INTELLIGENT ENERGY PLATFORM',
          style: TextStyle(
            fontFamily: 'Paperlogy',
            color: AppTheme.textLow.withOpacity(0.6),
            fontSize: 20.sp,
            letterSpacing: 2.w,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
