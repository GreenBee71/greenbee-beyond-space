import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/admin_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/molecules/admin_visitor_card.dart';
import '../widgets/molecules/master_header.dart';

class AdminVisitorManagementPage extends ConsumerWidget {
  const AdminVisitorManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitorsAsync = ref.watch(allVisitorsProvider);

    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 64.h),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1400.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MasterHeader(
                  title: 'Visitor Management',
                  subtitle: 'Scheduled Visitors',
                  onRefresh: () => ref.invalidate(allVisitorsProvider),
                ),
                SizedBox(height: 48.h),
                visitorsAsync.when(
                  data: (visitors) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visitors.length,
                    itemBuilder: (context, index) {
                      final visitor = visitors[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: AdminVisitorCard(
                          visitor: visitor,
                          onApprove: () => _updateStatus(ref, visitor.id, 'APPROVED'),
                          onReject: () => _updateStatus(ref, visitor.id, 'REJECTED'),
                        ),
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                  error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.redAccent, fontSize: 14.sp))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateStatus(WidgetRef ref, int id, String status) async {
    try {
      await ref.read(adminRepositoryProvider).updateVisitorStatus(id, status);
      ref.invalidate(allVisitorsProvider);
    } catch (e) {
      // Handle error
    }
  }
}
