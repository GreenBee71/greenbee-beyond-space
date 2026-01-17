import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/models/energy_coach.dart';

class EnergyCoachCard extends StatelessWidget {
  final EnergyCoachResponse coach;

  const EnergyCoachCard({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.neonGreen.withOpacity(0.15),
            Colors.black.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.neonGreen.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonGreen.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                _buildScoreGauge(),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI 에너지 코치 분석',
                        style: TextStyle(fontFamily: 'Paperlogy', 
                          color: AppTheme.neonGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        coach.summary,
                        style: const TextStyle(fontFamily: 'Paperlogy', 
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: coach.tips.map((tip) => _buildTipTile(tip)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreGauge() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: coach.score / 100,
            strokeWidth: 8,
            backgroundColor: Colors.white10,
            color: _getScoreColor(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${coach.score}',
                style: TextStyle(fontFamily: 'Paperlogy', 
                  color: _getScoreColor(),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                '점',
                style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipTile(EnergyCoachTip tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _getTipColor(tip.impactLevel).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTipIcon(tip.category),
              size: 16,
              color: _getTipColor(tip.impactLevel),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: const TextStyle(fontFamily: 'Paperlogy', 
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.content,
                  style: TextStyle(fontFamily: 'Paperlogy', 
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor() {
    if (coach.score >= 90) return AppTheme.neonGreen;
    if (coach.score >= 70) return Colors.blueAccent;
    return Colors.orangeAccent;
  }

  Color _getTipColor(String level) {
    switch (level) {
      case 'HIGH': return Colors.redAccent;
      case 'MEDIUM': return Colors.amberAccent;
      default: return AppTheme.neonGreen;
    }
  }

  IconData _getTipIcon(String category) {
    switch (category) {
      case 'SAVING': return Icons.savings_outlined;
      case 'ENVIRONMENT': return Icons.eco_outlined;
      case 'PEER_COMPARE': return Icons.people_outline;
      default: return Icons.lightbulb_outline;
    }
  }
}
