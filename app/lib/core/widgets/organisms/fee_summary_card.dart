import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/admin_fee.dart';
import '../../theme/app_theme.dart';
import '../atoms/glass_container.dart';

class FeeSummaryCard extends StatelessWidget {
  final AdminFee fee;

  const FeeSummaryCard({super.key, required this.fee});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');

    return GlassContainer(
      color: AppTheme.accentMint,
      opacity: 0.1,
      child: Column(
        children: [
          Text('${fee.billingMonth} 청구분', style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          Text(
            currency.format(fee.totalAmount),
            style: const TextStyle(fontFamily: 'Paperlogy', 
              color: AppTheme.accentMint,
              fontSize: 34,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(fee.status == 'PAID' ? '납부완료' : '미납'),
            backgroundColor: fee.status == 'PAID' ? AppTheme.accentMint.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            labelStyle: TextStyle(fontFamily: 'Paperlogy', 
              color: fee.status == 'PAID' ? AppTheme.accentMint : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
