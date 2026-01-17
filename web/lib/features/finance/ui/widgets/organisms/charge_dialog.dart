import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';
import 'package:greenbee_web/features/finance/providers/finance_provider.dart';

class ChargeDialog extends ConsumerStatefulWidget {
  const ChargeDialog({super.key});

  @override
  ConsumerState<ChargeDialog> createState() => _ChargeDialogState();
}

class _ChargeDialogState extends ConsumerState<ChargeDialog> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleCharge() async {
    final amount = double.tryParse(_controller.text);
    if (amount != null && amount > 0) {
      setState(() => _isLoading = true);
      try {
        await ref.read(greenPayRepositoryProvider).charge(amount);
        ref.invalidate(walletProvider);
        ref.invalidate(transactionsProvider);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Charge failed: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.navyMedium,
      title: const Text('GreenPay 충전', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontWeight: FontWeight.w500)),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white),
        decoration: const InputDecoration(
          labelText: '충전 금액',
          labelStyle: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow),
          suffixText: 'KRW',
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleCharge,
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonGreen, foregroundColor: Colors.black),
          child: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
            : const Text('충전하기'),
        ),
      ],
    );
  }
}
