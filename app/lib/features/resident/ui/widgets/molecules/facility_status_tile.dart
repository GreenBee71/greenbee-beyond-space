import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class FacilityStatusTile extends StatelessWidget {
  final String name;
  final int currentOccupancy;
  final int totalCapacity;
  final IconData icon;

  const FacilityStatusTile({
    super.key,
    required this.name,
    required this.currentOccupancy,
    required this.totalCapacity,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = currentOccupancy < totalCapacity * 0.5 
        ? AppTheme.accentMint 
        : (currentOccupancy < totalCapacity * 0.8 ? Colors.orange : AppTheme.alertRed);
    
    final statusText = currentOccupancy < totalCapacity * 0.5 
        ? '여유' 
        : (currentOccupancy < totalCapacity * 0.8 ? '보통' : '혼잡');

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.textMedium, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 14, fontWeight: FontWeight.w500)),
                Text('$currentOccupancy / $totalCapacity 명 이용중', style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: statusColor.withOpacity(0.2), width: 0.5),
            ),
            child: Text(
              statusText,
              style: TextStyle(fontFamily: 'Paperlogy', color: statusColor, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
