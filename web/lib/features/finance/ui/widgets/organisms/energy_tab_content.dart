import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../providers/finance_provider.dart';
import '../organisms/energy_bar_chart.dart';
import '../molecules/energy_coach_card.dart';

class EnergyTabContent extends ConsumerWidget {
  const EnergyTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energyAsync = ref.watch(energyHistoryProvider);

    return energyAsync.when(
      data: (history) {
        if (history.isEmpty) return const Center(child: Text('데이터 없음'));
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('최근 6개월 전기 사용량 (kWh)', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
              const SizedBox(height: 24),
              EnergyBarChart(history: history),
              const SizedBox(height: 24),
              // AI Coach Section
              ref.watch(energyCoachProvider).when(
                data: (coach) => EnergyCoachCard(coach: coach),
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.neonGreen)),
                error: (err, __) => Center(child: Text('AI 코치 데이터를 불러오지 못했습니다: $err')),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
