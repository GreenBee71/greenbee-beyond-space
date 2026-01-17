import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../providers/living_provider.dart';

class EnergyChallengePage extends ConsumerWidget {
  const EnergyChallengePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(challengesProvider);

    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        title: const Text('에너지 관리', style: TextStyle(fontFamily: 'Paperlogy')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: challengesAsync.when(
        data: (challenges) {
          if (challenges.isEmpty) {
            return _buildEmptyState();
          }
          return GridView.builder(
            padding: EdgeInsets.all(24.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.8,
            ),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return _buildChallengeCard(challenge);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentMint)),
        error: (err, stack) => Center(child: Text('Error loading challenges: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildChallengeCard(Map<String, dynamic> challenge) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppTheme.accentMint.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.bolt, color: const Color(0xFFFFD700), size: 20.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${FormatUtils.formatNumber(challenge['reward_points'] ?? 0)} P',
                  style: TextStyle(
                    fontFamily: 'Paperlogy',
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFFD700),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            challenge['title'] ?? 'Challenge',
            style: TextStyle(
              fontFamily: 'Paperlogy',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textHigh,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(2.r),
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentMint),
              minHeight: 4.h,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '60% 진행 중',
            style: TextStyle(
              fontFamily: 'Paperlogy',
              fontSize: 12.sp,
              color: AppTheme.textLow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 64.w, color: AppTheme.textLow),
          SizedBox(height: 16.h),
          Text(
            '진행 중인 챌린지가 없습니다.',
            style: TextStyle(
              fontFamily: 'Paperlogy',
              color: AppTheme.textMedium,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
