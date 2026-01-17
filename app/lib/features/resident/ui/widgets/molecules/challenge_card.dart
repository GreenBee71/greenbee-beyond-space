import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final int reward;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.progress,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentMint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ACTIVE CHALLENGE',
                  style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '+ ${reward.toString()}P',
                style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.accentMint,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(color: AppTheme.accentMint.withOpacity(0.3), blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress: ${(progress * 100).toInt()}%',
                style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 12),
              ),
              const Text(
                '12 days left',
                style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
