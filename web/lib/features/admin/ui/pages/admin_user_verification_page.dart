import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/admin_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/molecules/admin_user_card.dart';
import '../widgets/molecules/master_header.dart';

class AdminUserVerificationPage extends ConsumerWidget {
  const AdminUserVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unverifiedAsync = ref.watch(unverifiedUsersProvider);

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
                  title: 'User Verification',
                  subtitle: 'Unverified Residents',
                  onRefresh: () => ref.invalidate(unverifiedUsersProvider),
                ),
                SizedBox(height: 48.h),
                unverifiedAsync.when(
                  data: (users) {
                    if (users.isEmpty) {
                      return Center(
                        child: Text(
                          'No unverified users.',
                          style: TextStyle(
                            fontFamily: 'Paperlogy',
                            color: AppTheme.textLow,
                            fontSize: 16.sp,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: AdminUserCard(
                            user: user,
                            onVerify: () => _verifyUser(ref, user['user_id']),
                          ),
                        );
                      },
                    );
                  },
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

  Future<void> _verifyUser(WidgetRef ref, int userId) async {
    try {
      await ref.read(adminRepositoryProvider).verifyUser(userId);
      ref.invalidate(unverifiedUsersProvider);
    } catch (e) {
      // Handle error
    }
  }
}
