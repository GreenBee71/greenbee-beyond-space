import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/master_provider.dart';
import '../widgets/molecules/announcement_list_item.dart';

class MasterAnnouncementPage extends ConsumerWidget {
  const MasterAnnouncementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        title: Text('System Announcements', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 20.sp, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 24.sp),
            onPressed: () => ref.invalidate(announcementsProvider),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Global Broadcast',
              style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Text(
              'Send important updates to all complexes or specific locations',
              style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white.withOpacity(0.6), fontSize: 16.sp),
            ),
            SizedBox(height: 32.h),
            Expanded(
              child: announcementsAsync.when(
                data: (announcements) {
                  if (announcements.isEmpty) {
                    return Center(
                      child: Text('No announcements sent yet.', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 15.sp)),
                    );
                  }
                  return ListView.builder(
                    itemCount: announcements.length,
                    itemBuilder: (context, index) => AnnouncementListItem(item: announcements[index]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.red, fontSize: 14.sp))),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAnnouncementDialog(context, ref),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.black,
        icon: Icon(Icons.campaign, size: 24.sp),
        label: Text('New Broadcast', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 14.sp, fontWeight: FontWeight.w500)),
      ),
    );
  }

  void _showCreateAnnouncementDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String target = 'ALL';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.navyMedium,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('Create Global Announcement', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 15.sp),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 14.sp),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 15.sp),
                  decoration: InputDecoration(
                    labelText: 'Content',
                    labelStyle: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 14.sp),
                  ),
                ),
                SizedBox(height: 16.h),
                Consumer(
                  builder: (context, ref, _) {
                    return ref.watch(complexesProvider).when(
                      data: (list) => DropdownButtonFormField<String>(
                        value: target,
                        dropdownColor: AppTheme.navyMedium,
                        style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 15.sp),
                        decoration: InputDecoration(
                          labelText: 'Target Complex',
                          labelStyle: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 14.sp),
                        ),
                        items: [
                          const DropdownMenuItem(value: 'ALL', child: Text('전체 공지 (ALL)')),
                          ...list.map((e) => DropdownMenuItem(
                            value: e['name'] as String, 
                            child: Text(e['name'] as String)
                          )),
                        ],
                        onChanged: (val) => setState(() => target = val!),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => Text('Failed to load complexes', style: TextStyle(color: Colors.red, fontSize: 12.sp)),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 14.sp)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  try {
                    await ref.read(masterRepositoryProvider).createAnnouncement(
                      titleController.text,
                      contentController.text,
                      target,
                    );
                    ref.invalidate(announcementsProvider);
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
              child: Text('Broadcast', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 14.sp, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
