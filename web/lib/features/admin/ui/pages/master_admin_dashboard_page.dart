import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/master_provider.dart';
import '../../../../core/widgets/molecules/nav_card.dart';
import '../widgets/molecules/master_header.dart';
import '../widgets/organisms/master_stats_grid.dart';
import '../widgets/organisms/bulk_billing_section.dart';
import '../widgets/organisms/master_trend_charts_section.dart';
import '../widgets/organisms/master_iot_monitoring_section.dart';
import '../templates/master_dashboard_template.dart';

class MasterAdminDashboardPage extends ConsumerWidget {
  const MasterAdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(globalStatsProvider);
    final iotAsync = ref.watch(iotStatsProvider);
    final trendsAsync = ref.watch(trendsStatsProvider);

    return MasterDashboardTemplate(
      header: MasterHeader(
        title: 'Master Control Center',
        subtitle: 'Global overview and system-wide management',
        onRefresh: () {
          ref.invalidate(globalStatsProvider);
          ref.invalidate(iotStatsProvider);
          ref.invalidate(trendsStatsProvider);
        },
      ),
      statsGrid: statsAsync.when(
        data: (stats) => MasterStatsGrid(stats: stats),
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentMint)),
        error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.red))),
      ),
      analyticsSection: trendsAsync.when(
        data: (trends) => MasterTrendChartsSection(trends: trends),
        loading: () => Container(
          height: 300.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: const Center(child: CircularProgressIndicator(color: AppTheme.accentMint)),
        ),
        error: (err, _) => const SizedBox.shrink(),
      ),
      iotSection: iotAsync.when(
        data: (iot) => MasterIoTMonitoringSection(iotStats: iot),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
      actionSection: const BulkBillingSection(),
      navigationCards: [
        NavCard(
          title: 'Managed Complexes',
          subtitle: 'Register new complexes, manage admins, and monitor status.',
          icon: Icons.apartment,
          onTap: () => context.push('/admin/master/complexes'),
          actionLabel: 'View All',
          onActionPressed: () => context.push('/admin/master/complexes'),
        ),
        NavCard(
          title: 'Global User Control',
          subtitle: 'Search, verify, and manage roles for all users in the system.',
          icon: Icons.people,
          onTap: () => context.push('/admin/master/users'),
          actionLabel: 'Manage Users',
          onActionPressed: () => context.push('/admin/master/users'),
        ),
        NavCard(
          title: 'System Announcements',
          subtitle: 'Publish notices and emergency alerts to all complexes or residents.',
          icon: Icons.campaign,
          onTap: () => context.push('/admin/master/announcements'),
          actionLabel: 'New Broadcast',
          onActionPressed: () => context.push('/admin/master/announcements'),
        ),
      ],
    );
  }
}
