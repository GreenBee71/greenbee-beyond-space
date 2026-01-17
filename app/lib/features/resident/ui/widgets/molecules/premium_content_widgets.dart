import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class TalentTile extends StatelessWidget {
  final String title;
  final String provider;
  final int price;
  final String time;

  const TalentTile({
    super.key,
    required this.title,
    required this.provider,
    required this.price,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentMint.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.volunteer_activism_outlined, color: AppTheme.accentMint, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text('$provider • $time', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium.withOpacity(0.7), fontSize: 12)),
                ],
              ),
            ),
            Text('${price}P', style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class SocialClubCard extends StatelessWidget {
  final String name;
  final String category;
  final IconData icon;

  const SocialClubCard({
    super.key,
    required this.name,
    required this.category,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.all(0),
            child: Center(child: Icon(icon, size: 40, color: AppTheme.textHigh.withOpacity(0.5))),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 12, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis)),
          Text(category, style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium.withOpacity(0.6), fontSize: 12)),
        ],
      ),
    );
  }
}
