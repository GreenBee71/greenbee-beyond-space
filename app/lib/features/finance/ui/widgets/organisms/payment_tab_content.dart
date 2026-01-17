import 'package:flutter/material.dart';
import '../../../../../core/widgets/atoms/neon_button.dart';
import '../organisms/payment_method_list.dart';

class PaymentTabContent extends StatelessWidget {
  const PaymentTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const PaymentMethodList(),
          const SizedBox(height: 32),
          NeonButton(
            label: '결제 수단 추가',
            icon: Icons.add,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
