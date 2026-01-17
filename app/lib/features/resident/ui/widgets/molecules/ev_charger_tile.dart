import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';

class EVChargerTile extends StatelessWidget {
  final String location;
  final String status;

  const EVChargerTile({
    super.key,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    
    switch (status) {
      case 'AVAILABLE':
        statusColor = AppTheme.accentMint;
        statusLabel = '사용 가능';
        break;
      case 'CHARGING':
        statusColor = Colors.orange;
        statusLabel = '충전 중';
        break;
      default:
        statusColor = AppTheme.textLow;
        statusLabel = '점검 중';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.glassBorder, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.ev_station, color: statusColor, size: 20),
              const SizedBox(width: 12),
              Text(location, style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 12)),
            ],
          ),
          Text(statusLabel, style: TextStyle(fontFamily: 'Paperlogy', color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
