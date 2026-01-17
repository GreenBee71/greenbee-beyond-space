import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class ConciergeSuggestionCard extends StatelessWidget {
  final String title;
  final String description;
  final String actionLabel;
  final String type;
  final VoidCallback onAction;

  const ConciergeSuggestionCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.type,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  type == 'IoT_MAINTENANCE' ? Icons.build_circle_outlined : Icons.auto_awesome_outlined,
                  color: AppTheme.accentMint,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 12, height: 1.5),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  backgroundColor: AppTheme.accentMint.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
