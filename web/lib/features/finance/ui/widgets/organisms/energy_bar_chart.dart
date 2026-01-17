import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/atoms/glass_container.dart';

class EnergyBarChart extends StatelessWidget {
  final List<dynamic> history;

  const EnergyBarChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('월별 에너지 사용량', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 16)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: history.map((item) {
                final height = (item.electricity / 500) * 150.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.neonGreen, Colors.blueAccent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(item.month.toString(), style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white38, fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
