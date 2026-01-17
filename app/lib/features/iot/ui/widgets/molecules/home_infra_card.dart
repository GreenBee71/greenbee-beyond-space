import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class HomeInfraCard extends StatelessWidget {
  final String title;
  final String manufacturer;
  final String type;
  final Map<String, dynamic> state;
  final VoidCallback onTap;

  const HomeInfraCard({
    super.key,
    required this.title,
    required this.manufacturer,
    required this.type,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIcon(),
                color: AppTheme.accentMint,
                size: 24,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 12, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _getStatusText(),
                style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case 'WALLPAD': return Icons.settings_input_component_outlined;
      case 'DOORLOCK': return Icons.lock_open_outlined;
      case 'THERMOSTAT': return Icons.thermostat_outlined;
      case 'GAS_VALVE': return Icons.vaping_rooms_outlined;
      default: return Icons.home_repair_service_outlined;
    }
  }

  String _getStatusText() {
    if (type == 'DOORLOCK') return state['locked'] == true ? 'Locked' : 'Unlocked';
    if (type == 'THERMOSTAT') return '${state['temp']}°C';
    if (type == 'GAS_VALVE') return state['status'] ?? 'Checked';
    return manufacturer;
  }
}
