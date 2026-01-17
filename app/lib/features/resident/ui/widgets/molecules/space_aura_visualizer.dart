import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:greenbee_app/core/theme/app_theme.dart';

class SpaceAuraVisualizer extends StatefulWidget {
  final int activeDeviceCount;
  final String status;

  const SpaceAuraVisualizer({
    super.key,
    required this.activeDeviceCount,
    required this.status,
  });

  @override
  State<SpaceAuraVisualizer> createState() => _SpaceAuraVisualizerState();
}

class _SpaceAuraVisualizerState extends State<SpaceAuraVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
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
          size: Size.infinite,
          painter: AuraPainter(
            animationValue: _controller.value,
            activeDeviceCount: widget.activeDeviceCount,
            status: widget.status,
          ),
        );
      },
    );
  }
}

class AuraPainter extends CustomPainter {
  final double animationValue;
  final int activeDeviceCount;
  final String status;

  AuraPainter({
    required this.animationValue,
    required this.activeDeviceCount,
    required this.status,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    
    // Choose aura colors based on status
    final Color primaryColor = status == 'Optimal' 
        ? AppTheme.accentMint 
        : (activeDeviceCount > 0 ? Colors.blueAccent : AppTheme.textLow);
    
    final Paint paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          0.5 + 0.1 * math.sin(animationValue * 2 * math.pi),
          0.3 + 0.1 * math.cos(animationValue * 2 * math.pi),
        ),
        colors: [
          primaryColor.withOpacity(0.15),
          primaryColor.withOpacity(0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);

    // Drawing multiple overlapping aura circles for a "breathing" effect
    for (int i = 0; i < 3; i++) {
      final double breath = math.sin(animationValue * 2 * math.pi + (i * 0.8)) * 20.0;
      final double radius = (size.width * 0.4) + breath;
      canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.3),
        radius,
        paint,
      );
    }
    
    // Subtle Mesh-like particles
    if (status == 'Optimal') {
      final particlePaint = Paint()..color = primaryColor.withOpacity(0.2);
      final random = math.Random(42);
      for (int i = 0; i < 15; i++) {
        final double x = random.nextDouble() * size.width;
        final double y = random.nextDouble() * size.height * 0.6;
        final double float = math.sin(animationValue * 2 * math.pi + i) * 5.0;
        canvas.drawCircle(Offset(x, y + float), 1.5, particlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AuraPainter oldDelegate) => true;
}
