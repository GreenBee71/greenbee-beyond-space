import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../providers/finance_provider.dart';
import '../molecules/fee_summary_card.dart';
import '../../../../../core/widgets/atoms/glass_container.dart';

class FeeTabContent extends ConsumerWidget {
  const FeeTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingAsync = ref.watch(latestFeeProvider);

    return billingAsync.when(
      data: (billing) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FeeSummaryCard(
              title: '${billing.billingMonth} 납부하실 금액',
              amount: '₩${_formatAmount(billing.totalAmount.toInt())}',
              dueDate: '2024-01-31', 
              isPaid: billing.status == 'PAID',
              onPayPressed: billing.status == 'UNPAID' ? () => _showPaymentDialog(context, ref, billing) : null,
            ),
            const SizedBox(height: 16),
            _buildGreenPayBanner(context, ref),
            const SizedBox(height: 24),
            const Text('상세 내역', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
            const SizedBox(height: 16),
            ...billing.details.entries.map((entry) => ListTile(
              title: Text(_translateKey(entry.key), style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium)),
              trailing: Text('₩${_formatAmount(entry.value is int ? entry.value : (entry.value as num).toInt())}', style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontWeight: FontWeight.w500)),
            )),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  String _translateKey(String key) {
    final map = {
      'general_mgmt': '일반관리비',
      'security': '경비비',
      'cleaning': '청소비',
      'elevator': '승강기유지비',
      'community': '커뮤니티시설비',
      'energy_electric': '세대 전기료',
      'energy_water': '세대 수도료',
      'energy_heating': '세대 난방비',
    };
    return map[key] ?? key;
  }

  Widget _buildGreenPayBanner(BuildContext context, WidgetRef ref) {
    return GlassContainer(
      child: InkWell(
        onTap: () => context.push('/finance/greenpay'),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.neonGreen.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.account_balance_wallet, color: AppTheme.neonGreen, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GreenPay Wallet', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontWeight: FontWeight.w500)),
                  Text('간편 충전하고 관리비 납부 시 포인트 적립', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, WidgetRef ref, dynamic billing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.navyMedium,
        title: const Text('GreenPay 결제', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white)),
        content: Text('총 ${_formatAmount(billing.totalAmount.toInt())}원을 GreenPay로 결제하시겠습니까?', style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          ElevatedButton(
            onPressed: () async {
              try {
                // Mock payment for now or add actual pay call
                await ref.read(greenPayRepositoryProvider).pay(
                  billing.totalAmount.toDouble(), 
                  '${billing.billingMonth} 관리비 납부',
                  feeId: billing.id,
                );
                // We'd also need to update the admin fee status in a real scenario
                ref.invalidate(latestFeeProvider);
                ref.invalidate(walletProvider);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                // Insufficient balance etc
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonGreen, foregroundColor: Colors.black),
            child: const Text('결제하기'),
          ),
        ],
      ),
    );
  }
}
