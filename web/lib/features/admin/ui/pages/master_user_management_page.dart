import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/master_provider.dart';
import '../widgets/molecules/user_list_item.dart';
import '../widgets/molecules/master_header.dart';

class MasterUserManagementPage extends ConsumerWidget {
  const MasterUserManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

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
                  title: 'Global User Management',
                  subtitle: 'View and manage all registered users across all complexes',
                  onRefresh: () => ref.invalidate(allUsersProvider),
                ),
                SizedBox(height: 48.h),
                usersAsync.when(
                  data: (users) {
                    if (users.isEmpty) {
                      return Center(
                        child: Text(
                          'No users found.',
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
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: UserListItem(
                          user: users[index],
                          onRoleChange: (newRole) => _handleRoleChange(context, ref, users[index]['id'], newRole),
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                  error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.red, fontSize: 14.sp))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRoleChange(BuildContext context, WidgetRef ref, int userId, String newRole) async {
    try {
      await ref.read(masterRepositoryProvider).updateUserRole(userId, newRole);
      ref.invalidate(allUsersProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User role updated to $newRole'), backgroundColor: AppTheme.primaryGreen)
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update role: $e')));
      }
    }
  }
}
