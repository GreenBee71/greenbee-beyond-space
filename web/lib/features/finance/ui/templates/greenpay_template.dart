import 'package:flutter/material.dart';

class GreenPayTemplate extends StatelessWidget {
  final Widget walletCard;
  final Widget transactionsList;
  final Future<void> Function() onRefresh;

  const GreenPayTemplate({
    super.key,
    required this.walletCard,
    required this.transactionsList,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('GreenPay Wallet'),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: walletCard,
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  '최근 거래 내역',
                  style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            transactionsList,
          ],
        ),
      ),
    );
  }
}
