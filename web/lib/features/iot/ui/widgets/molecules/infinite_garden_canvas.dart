import 'package:flutter/material.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';
import 'package:greenbee_web/core/widgets/atoms/glass_container.dart';

class InfiniteGardenCanvas extends StatelessWidget {
  final double score; // 0 to 100
  final String level; // Lush, Growing, Dry

  const InfiniteGardenCanvas({
    super.key,
    required this.score,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Infinite Garden', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontWeight: FontWeight.w500, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getLevelColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getLevelColor().withOpacity(0.5)),
                ),
                child: Text(
                  level,
                  style: TextStyle(fontFamily: 'Paperlogy', color: _getLevelColor(), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: GardenPainter(score: score, color: _getLevelColor()),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Eco-Score: ', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium)),
              Text('${score.toInt()}', style: TextStyle(fontFamily: 'Paperlogy', color: _getLevelColor(), fontSize: 20, fontWeight: FontWeight.w500)),
              Text('/100', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLevelColor() {
    switch (level) {
      case 'Lush': return AppTheme.accentMint;
      case 'Growing': return Colors.amberAccent;
      case 'Dry': return Colors.deepOrangeAccent;
      default: return AppTheme.accentMint;
    }
  }
}

class GardenPainter extends CustomPainter {
  final double score;
  final Color color;

  GardenPainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final double midY = size.height / 2;
    
    // Draw abstract "energy waves" that look like organic growth
    // Height and frequency depend on score
    for (double x = 0; x <= size.width; x++) {
      double y = midY + (50 * (score / 100)) * 
          (0.5 * (1 + (x / size.width)) * (1 - (x / size.width))) * 
          (score > 50 ? 1 : 0.5); // Just a simple curve as a placeholder
      
      if (x == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    
    canvas.drawPath(path, paint);
    
    // Draw some "leaves" or "nodes" based on score
    final nodeCount = (score / 10).toInt();
    for (int i = 0; i < nodeCount; i++) {
      final double x = (size.width / (nodeCount + 1)) * (i + 1);
      final double y = midY;
      canvas.drawCircle(Offset(x, y), 4 * (score / 100), paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
