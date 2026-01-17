import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class LoginTemplate extends StatelessWidget {
  final Widget logo;
  final List<Widget> fields;
  final Widget loginButton;
  final Widget? helperButtons;

  const LoginTemplate({
    super.key,
    required this.logo,
    required this.fields,
    required this.loginButton,
    this.helperButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.navyDark, AppTheme.navyMedium],
          ),
        ),
        child: Stack(
        children: [
          // Premium Background Aura
          Positioned.fill(
            child: _AnimatedAuraBackground(),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: GlassContainer(
                padding: EdgeInsets.all(40.r),
                borderRadius: BorderRadius.circular(32.r),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 340.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      logo,
                      SizedBox(height: 48.h),
                      ...fields.expand((f) => [f, SizedBox(height: 20.h)]),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.infinity,
                        child: loginButton,
                      ),
                      if (helperButtons != null) ...[
                        SizedBox(height: 32.h),
                        helperButtons!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _AnimatedAuraBackground extends StatefulWidget {
  @override
  State<_AnimatedAuraBackground> createState() => _AnimatedAuraBackgroundState();
}

class _AnimatedAuraBackgroundState extends State<_AnimatedAuraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _AuraPainter(_controller.value),
        );
      },
    );
  }
}

class _AuraPainter extends CustomPainter {
  final double progress;
  _AuraPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    
    // Primary Glow
    final double angle = progress * 2 * math.pi;
    final primaryGlowCenter = Offset(
      center.dx + math.sin(angle) * (size.width * 0.1),
      center.dy + math.cos(angle) * (size.height * 0.1),
    );

    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.accentMint.withOpacity(0.15),
          AppTheme.accentMint.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: primaryGlowCenter, radius: size.width * 0.6));
    
    canvas.drawRect(Offset.zero & size, paint1);

    // Secondary Glow
    final secondaryGlowCenter = Offset(
      center.dx + math.sin(angle + math.pi) * (size.width * 0.2),
      center.dy + math.cos(angle + math.pi) * (size.height * 0.2),
    );

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4A90E2).withOpacity(0.1),
          const Color(0xFF4A90E2).withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: secondaryGlowCenter, radius: size.width * 0.5));
    
    canvas.drawRect(Offset.zero & size, paint2);
  }

  @override
  bool shouldRepaint(_AuraPainter oldDelegate) => true;
}
