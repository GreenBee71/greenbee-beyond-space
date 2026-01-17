import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/master_provider.dart';
import '../widgets/molecules/complex_list_item.dart';
import '../widgets/molecules/master_header.dart';

class MasterComplexManagementPage extends ConsumerWidget {
  const MasterComplexManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complexesAsync = ref.watch(complexesProvider);

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
                  title: 'Complex Management',
                  subtitle: 'Overview of all residential complexes in the system',
                  onRefresh: () => ref.invalidate(complexesProvider),
                ),
                SizedBox(height: 48.h),
                complexesAsync.when(
                  data: (complexes) {
                    if (complexes.isEmpty) {
                      return Center(
                        child: Text(
                          'No complexes registered yet.',
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
                      itemCount: complexes.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: ComplexListItem(
                          complex: complexes[index],
                          onDelete: () => _handleDelete(context, ref, complexes[index]['name']),
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                  error: (err, stack) => Center(
                    child: Text(
                      'Error: $err',
                      style: TextStyle(
                        fontFamily: 'Paperlogy',
                        color: Colors.red,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddComplexDialog(context, ref),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.black,
        icon: Icon(Icons.add, size: 24.sp),
        label: Text('Add Complex', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 14.sp, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.navyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Confirm Deletion', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500)),
        content: Text('Are you sure you want to delete $name? This will remove all associated user data.', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 14.sp)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 14.sp))),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: Text('Delete', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.redAccent, fontSize: 14.sp, fontWeight: FontWeight.w500))
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(masterRepositoryProvider).deleteComplex(name);
        ref.invalidate(complexesProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
        }
      }
    }
  }

  void _showAddComplexDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.navyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Add New Complex', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500)),
        content: TextField(
          controller: controller,
          style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 15.sp),
          decoration: InputDecoration(
            labelText: 'Complex Name',
            labelStyle: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 14.sp),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 14.sp)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await ref.read(masterRepositoryProvider).createComplex(controller.text);
                  ref.invalidate(complexesProvider);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  // handle error
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen, 
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text('Create', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 14.sp, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
