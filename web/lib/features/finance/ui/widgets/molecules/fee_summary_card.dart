import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/atoms/glass_container.dart';

class FeeSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String dueDate;
  final bool isPaid;
  final VoidCallback? onPayPressed;

  const FeeSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
    this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 16)),
              if (isPaid)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.neonGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('납부 완료', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.neonGreen, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(amount, style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 28, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('납부 기한: $dueDate', style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white38, fontSize: 14)),
          if (onPayPressed != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPayPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonGreen,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('GreenPay로 납부하기', style: TextStyle(fontFamily: 'Paperlogy', fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
