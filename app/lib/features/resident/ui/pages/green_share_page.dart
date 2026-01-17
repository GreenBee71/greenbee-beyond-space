import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/living_provider.dart';

class GreenSharePage extends ConsumerWidget {
  const GreenSharePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.deepSpace,
        appBar: AppBar(
          title: const Text('그린 쉐어', style: TextStyle(fontFamily: 'Paperlogy')),
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
              Tab(text: '나눔 마켓'),
              Tab(text: '재능 교환'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ShareItemsTab(ref),
            _TalentExchangeTab(ref),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: const Color(0xFFFD9644),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('글쓰기', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}

class _ShareItemsTab extends StatelessWidget {
  final WidgetRef ref;
  const _ShareItemsTab(this.ref);

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(shareItemsProvider);

    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Text(
              '나눔 물품이 없습니다.',
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
            childAspectRatio: 0.75,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildItemCard(item);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentMint)),
      error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Center(
                child: Icon(Icons.image, size: 40.w, color: Colors.white.withOpacity(0.3)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? '제목 없음',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontWeight: FontWeight.w500, fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  item['description'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 12.sp),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD9644).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text('무료나눔', style: TextStyle(fontFamily: 'Paperlogy', color: const Color(0xFFFD9644), fontSize: 12.sp)),
                    ),
                    Icon(Icons.favorite_border, size: 16.w, color: AppTheme.textLow),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TalentExchangeTab extends StatelessWidget {
  final WidgetRef ref;
  const _TalentExchangeTab(this.ref);

  @override
  Widget build(BuildContext context) {
    final talentsAsync = ref.watch(talentExchangeProvider);

    return talentsAsync.when(
      data: (talents) {
        if (talents.isEmpty) {
          return Center(
            child: Text(
              '등록된 재능이 없습니다.',
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
            childAspectRatio: 0.85,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: talents.length,
          itemBuilder: (context, index) {
            final talent = talents[index];
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFFD9644).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFD9644).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: const Color(0xFFFD9644), size: 20.w),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    talent['title'] ?? '재능 제목',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        talent['provider_name'] ?? '익명',
                        style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 12.sp),
                      ),
                      Text(
                        '요청',
                        style: TextStyle(fontFamily: 'Paperlogy', color: const Color(0xFFFD9644), fontSize: 12.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentMint)),
      error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
    );
  }
}
