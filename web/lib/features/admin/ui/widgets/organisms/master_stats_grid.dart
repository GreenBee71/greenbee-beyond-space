import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';
import 'package:greenbee_web/core/utils/format_utils.dart';
import '../molecules/master_stat_card.dart';

class MasterStatsGrid extends StatelessWidget {
  final Map<String, dynamic> stats;

  const MasterStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // Increased aspect ratio for a more 'dashboard card' feel on wide screens
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
      crossAxisSpacing: 32.w,
      mainAxisSpacing: 32.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: isDesktop ? 1.35 : 1.6,
      children: [
        MasterStatCard(
          title: 'Total Active Residents',
          value: FormatUtils.formatNumber(stats['total_users'] ?? 0),
          icon: Icons.group_outlined,
        ),
        MasterStatCard(
          title: 'Managed Complexes',
          value: FormatUtils.formatNumber(stats['total_complexes'] ?? 0),
          icon: Icons.business_outlined,
        ),
        MasterStatCard(
          title: 'Total Energy Consumption',
          value: '${FormatUtils.formatNumber(stats['total_electricity_kwh'] ?? 0)} kWh',
          icon: Icons.auto_graph_outlined,
        ),
        MasterStatCard(
          title: 'Global System Status',
          value: stats['system_status']?.toString().toUpperCase() ?? 'OPERATIONAL',
          icon: Icons.security_outlined,
          color: AppTheme.accentMint,
        ),
      ],
    );
  }
}
