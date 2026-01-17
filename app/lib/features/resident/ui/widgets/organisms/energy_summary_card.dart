import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class EnergySummaryCard extends StatelessWidget {
  final int lastUsage;

  const EnergySummaryCard({super.key, required this.lastUsage});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Energy Usage', 
                style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 12, fontWeight: FontWeight.w400)
              ),
              const SizedBox(height: 4),
              Text(
                '$lastUsage kWh', 
                style: const TextStyle(fontFamily: 'Paperlogy', 
                  color: AppTheme.textHigh,
                  fontSize: 26, 
                  fontWeight: FontWeight.w500, // Capped at 500
                  letterSpacing: -0.5,
                )
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentMint.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.electric_bolt_outlined, color: AppTheme.accentMint, size: 28),
          ),
        ],
      ),
    );
  }
}
