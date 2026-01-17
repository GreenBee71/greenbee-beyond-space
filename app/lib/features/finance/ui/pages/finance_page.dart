import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/organisms/fee_tab_content.dart';
import '../widgets/organisms/energy_tab_content.dart';
import '../widgets/organisms/payment_tab_content.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('납부 및 에너지'),
          bottom: const TabBar(
            indicatorColor: AppTheme.accentMint,
            labelColor: AppTheme.accentMint,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: '관리비 내역', icon: Icon(Icons.receipt_long)),
              Tab(text: '에너지 사용', icon: Icon(Icons.bolt)),
              Tab(text: '결제 관리', icon: Icon(Icons.payment)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FeeTabContent(),
            EnergyTabContent(),
            PaymentTabContent(),
          ],
        ),
      ),
    );
  }
}
