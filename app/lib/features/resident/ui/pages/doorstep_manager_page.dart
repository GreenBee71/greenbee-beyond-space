import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/living_provider.dart';

class DoorstepManagerPage extends ConsumerWidget {
  final int initialIndex;

  const DoorstepManagerPage({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialIndex,
      child: Scaffold(
        backgroundColor: AppTheme.deepSpace,
        appBar: AppBar(
          title: const Text('스마트 택배', style: TextStyle(fontFamily: 'Paperlogy')),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: AppTheme.accentMint,
            labelColor: AppTheme.textHigh,
            unselectedLabelColor: AppTheme.textLow,
            labelStyle: TextStyle(fontFamily: 'Paperlogy', fontWeight: FontWeight.w500),
            unselectedLabelStyle: TextStyle(fontFamily: 'Paperlogy'),
            tabs: [
              Tab(text: '스마트 택배'),
              Tab(text: '세탁 서비스'),
              Tab(text: '홈 케어'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ParcelTab(ref),
            _LaundryTab(),
            _HomeCareTab(),
          ],
        ),
      ),
    );
  }
}

class _ParcelTab extends StatelessWidget {
  final WidgetRef ref;
  const _ParcelTab(this.ref);

  @override
  Widget build(BuildContext context) {
    final deliveriesAsync = ref.watch(deliveriesProvider);

    return deliveriesAsync.when(
      data: (deliveries) {
        if (deliveries.isEmpty) {
          return Center(
             child: Text(
               '도착한 택배가 없습니다.', 
               style: TextStyle(
                 fontFamily: 'Paperlogy', 
                 color: AppTheme.textMedium, 
                 fontSize: 14.sp,
               ),
             ),
          );
        }
        return GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: deliveries.length,
          itemBuilder: (context, index) {
            final item = deliveries[index];
            return Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppTheme.textLow.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Icon(Icons.inventory_2_outlined, color: const Color(0xFF4A90E2), size: 24.sp),
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                         decoration: BoxDecoration(
                           color: const Color(0xFF4A90E2).withOpacity(0.1),
                           borderRadius: BorderRadius.circular(6.r),
                         ),
                         child: Text(
                           '도착',
                           style: TextStyle(
                             fontFamily: 'Paperlogy', 
                             color: const Color(0xFF4A90E2), 
                             fontSize: 12.sp
                           ),
                         ),
                       ),
                     ],
                   ),
                   const Spacer(),
                   Text(
                     item['item_name'] ?? '택배 물품',
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                     style: TextStyle(
                      fontFamily: 'Paperlogy', 
                      color: AppTheme.textHigh, 
                      fontSize: 14.sp, 
                      fontWeight: FontWeight.w500
                     ),
                   ),
                   SizedBox(height: 2.h),
                   Text(
                     item['tracking_number'] ?? '-',
                     style: TextStyle(
                       fontFamily: 'Paperlogy', 
                       color: AppTheme.textLow, 
                       fontSize: 12.sp
                     ),
                   ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentMint)),
      error: (err, _) => Center(child: Text('Load Error: $err', style: const TextStyle(color: Colors.red))),
    );
  }
}

class _LaundryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_laundry_service_outlined, size: 60.w, color: const Color(0xFFA55EEA).withOpacity(0.5)),
          SizedBox(height: 20.h),
          Text(
            '프리미엄 세탁 수거 신청',
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10.h),
          Text(
            '문 앞에 두시면 수거해 드립니다.\n(서비스 준비 중)',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class _HomeCareTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cleaning_services_outlined, size: 60.w, color: const Color(0xFF20BF6B).withOpacity(0.5)),
          SizedBox(height: 20.h),
          Text(
            '홈 케어 서비스',
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10.h),
          Text(
            '가사 도우미 및 청소 서비스 예약\n(서비스 준비 중)',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 14.sp),
          ),
          SizedBox(height: 30.h),
          ElevatedButton(
            onPressed: () {}, 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF20BF6B),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            ),
            child: Text(
              '상담 신청하기', 
              style: TextStyle(
                fontFamily: 'Paperlogy', 
                color: Colors.white, 
                fontWeight: FontWeight.w500, 
                fontSize: 14.sp
              ),
            ),
          )
        ],
      ),
    );
  }
}
