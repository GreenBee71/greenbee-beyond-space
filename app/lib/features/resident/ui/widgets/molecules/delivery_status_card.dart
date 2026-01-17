import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class DeliveryStatusCard extends StatelessWidget {
  final String courier;
  final String status;
  final String time;

  const DeliveryStatusCard({
    super.key,
    required this.courier,
    required this.status,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined, color: AppTheme.accentMint, size: 18),
              const SizedBox(width: 8),
              Text(
                status == 'ARRIVED' ? '택배가 도착했습니다' : '수령 완료',
                style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$courier | $time',
            style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 12),
          ),
          const SizedBox(height: 16),
          if (status == 'ARRIVED')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentMint.withOpacity(0.1),
                  foregroundColor: AppTheme.accentMint,
                  side: const BorderSide(color: AppTheme.accentMint, width: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('문 앞 배송 사진 보기', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }
}
