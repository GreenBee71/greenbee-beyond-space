import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/utils/format_utils.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isNegative ? AppTheme.alertRed : AppTheme.accentMint).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNegative ? Icons.remove_circle_outline : Icons.add_circle_outline,
                color: isNegative ? AppTheme.alertRed : AppTheme.accentMint,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description, 
                    style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 14, fontWeight: FontWeight.w500)
                  ),
                  Text(
                    DateFormat('yyyy.MM.dd HH:mm').format(createdAt),
                    style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '${isNegative ? "" : "+"}${FormatUtils.formatNumber(amount)}',
              style: TextStyle(fontFamily: 'Paperlogy', 
                color: isNegative ? Colors.white : AppTheme.accentMint,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
