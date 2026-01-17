import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';
import 'package:greenbee_web/core/widgets/atoms/glass_container.dart';
import 'package:greenbee_web/features/admin/providers/master_provider.dart';

class BulkBillingSection extends ConsumerWidget {
  const BulkBillingSection({super.key});

  Future<void> _handleUpload(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final content = String.fromCharCodes(file.bytes!);
      
      await ref.read(masterAdminActionProvider.notifier).uploadBillings(content, file.name);
      
      final state = ref.read(masterAdminActionProvider);
      if (context.mounted) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${state.error}'), backgroundColor: AppTheme.alertRed),
          );
        } else if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!), 
              backgroundColor: AppTheme.accentMint,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(masterAdminActionProvider);
    final isUploading = actionState.isUploading;

    return GlassContainer(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentMint.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.cloud_upload_outlined, color: AppTheme.accentMint, size: 32.sp),
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bulk Billing Systems',
                  style: TextStyle(fontFamily: 'Paperlogy', 
                    color: AppTheme.textHigh, 
                    fontSize: 18.sp, 
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2.w,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Automate monthly administrative fee processing for all managed complexes.',
                  style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          SizedBox(width: 24.w),
          ElevatedButton.icon(
            onPressed: isUploading ? null : () => _handleUpload(context, ref),
            icon: isUploading 
              ? SizedBox(width: 18.w, height: 18.w, child: CircularProgressIndicator(strokeWidth: 2.w, color: AppTheme.textHigh))
              : Icon(Icons.file_upload_outlined, size: 18.sp),
            label: Text(
              isUploading ? 'Sending...' : 'Upload Master CSV',
              style: TextStyle(fontFamily: 'Paperlogy', fontSize: 15.sp, fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.05),
              foregroundColor: AppTheme.textHigh,
              side: BorderSide(color: AppTheme.glassBorder, width: 0.5.w),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
            ),
          ),
        ],
      ),
    );
  }
}
