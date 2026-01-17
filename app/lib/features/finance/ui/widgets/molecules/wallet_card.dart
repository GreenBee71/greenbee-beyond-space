import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/utils/format_utils.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class WalletCard extends StatelessWidget {
  final double balance;
  final String currency;
  final VoidCallback onCharge;
  final VoidCallback onPay;

  const WalletCard({
    super.key,
    required this.balance,
    required this.currency,
    required this.onCharge,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      color: Colors.white,
      opacity: 0.02,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GreenPay Balance', 
                style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 14, fontWeight: FontWeight.w400)
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eco_outlined, color: AppTheme.accentMint, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${FormatUtils.formatNumber(balance)} $currency',
            style: const TextStyle(fontFamily: 'Paperlogy', 
              color: AppTheme.textHigh, 
              fontSize: 34, 
              fontWeight: FontWeight.w500,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              _buildActionButton(Icons.add_circle_outline, 'Charge', onCharge),
              const SizedBox(width: 16),
              _buildActionButton(Icons.qr_code_scanner, 'Quick Pay', onPay),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.accentMint, size: 18),
              const SizedBox(width: 10),
              Text(
                label, 
                style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 12, fontWeight: FontWeight.w500)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
