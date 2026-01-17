import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/finance_provider.dart';
import '../widgets/molecules/wallet_card.dart';
import '../widgets/molecules/transaction_tile.dart';
import '../widgets/organisms/charge_dialog.dart';
import '../templates/greenpay_template.dart';

class GreenPayPage extends ConsumerWidget {
  const GreenPayPage({super.key});

  void _showChargeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChargeDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);
    final transactionsAsync = ref.watch(transactionsProvider);

    return GreenPayTemplate(
      onRefresh: () async {
        ref.invalidate(walletProvider);
        ref.invalidate(transactionsProvider);
      },
      walletCard: walletAsync.when(
        data: (wallet) => WalletCard(
          balance: wallet.balance,
          currency: wallet.currency,
          onCharge: () => _showChargeDialog(context),
          onPay: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR 결제 기능은 준비 중입니다.')),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.neonGreen)),
        error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.red))),
      ),
      transactionsList: transactionsAsync.when(
        data: (txs) => SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final tx = txs[index];
              return TransactionTile(
                description: tx.description ?? tx.type,
                type: tx.type,
                amount: tx.amount,
                createdAt: tx.createdAt,
              );
            },
            childCount: txs.length,
          ),
        ),
        loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: AppTheme.neonGreen))),
        error: (err, _) => SliverToBoxAdapter(child: Center(child: Text('Error: $err', style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.red)))),
      ),
    );
  }
}
