import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../atoms/glass_container.dart';

class ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const ActivityTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentMint.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.accentMint, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: const TextStyle(fontFamily: 'Paperlogy', 
                      fontWeight: FontWeight.w500, 
                      color: AppTheme.textHigh,
                      fontSize: 14,
                    )
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle, 
                    style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 12)
                  ),
                ],
              ),
            ),
            Text(
              time, 
              style: const TextStyle(fontFamily: 'Paperlogy', fontSize: 12, color: AppTheme.textLow)
            ),
          ],
        ),
      ),
    );
  }
}
