import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final BoxBorder? border;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 12.0, 
    this.opacity = 0.03, 
    this.padding = const EdgeInsets.all(20), 
    this.borderRadius,
    this.color,
    this.border,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20.r), 
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: (color ?? Colors.white).withOpacity(opacity),
            borderRadius: borderRadius ?? BorderRadius.circular(20.r),
            border: border ?? Border.all(
              color: AppTheme.glassBorder,
              width: 0.5.w, 
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
