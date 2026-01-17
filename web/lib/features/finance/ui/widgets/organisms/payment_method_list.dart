import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/atoms/glass_container.dart';

class PaymentMethodList extends StatelessWidget {
  const PaymentMethodList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentItem(Icons.credit_card, '마이카드', '**** 1234'),
        const SizedBox(height: 12),
        _buildPaymentItem(Icons.account_balance, '그린은행', '110-***-123456'),
      ],
    );
  }

  Widget _buildPaymentItem(IconData icon, String name, String detail) {
    return GlassContainer(
      child: ListTile(
        leading: Icon(icon, color: AppTheme.textMedium),
        title: Text(name, style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white)),
        subtitle: Text(detail, style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow)),
        trailing: const Icon(Icons.check_circle, color: AppTheme.accentMint),
      ),
    );
  }
}
