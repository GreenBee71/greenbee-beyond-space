import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbee_app/features/finance/providers/finance_provider.dart';
import 'package:greenbee_app/features/resident/providers/living_provider.dart' as resident_living; 
import 'package:greenbee_app/features/iot/providers/iot_provider.dart';
import 'package:greenbee_app/features/resident/ui/widgets/molecules/home_menu_tile.dart';
import 'package:greenbee_app/features/resident/ui/templates/resident_home_template.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/molecules/group_card.dart';
import 'package:greenbee_app/features/resident/providers/menu_order_provider.dart';

class ResidentHomePage extends ConsumerWidget {
  const ResidentHomePage({super.key});

  static const Map<String, dynamic> menuData = {
    'energy': {'label': '에너지 관리', 'icon': Icons.bolt_rounded, 'color': Color(0xFFFFD700), 'path': '/energy'},
    'ev': {'label': '전기차 충전', 'icon': Icons.ev_station_rounded, 'color': Color(0xFF00FF88), 'path': '/ev'},
    'parcel': {'label': '스마트 택배', 'icon': Icons.inventory_2_outlined, 'color': Color(0xFF4A90E2), 'path': '/doorstep'},
    'community': {'label': '커뮤니티', 'icon': Icons.groups_2_rounded, 'color': Color(0xFFFF5252), 'path': '/community-hub'},
    'laundry': {'label': '세탁 서비스', 'icon': Icons.local_laundry_service_outlined, 'color': Color(0xFFA55EEA), 'path': '/doorstep?tab=1'},
    'homecare': {'label': '홈 케어', 'icon': Icons.cleaning_services_outlined, 'color': Color(0xFF20BF6B), 'path': '/doorstep?tab=2'},
    'garden': {'label': '인피니트 가든', 'icon': Icons.eco_rounded, 'color': Color(0xFF26DE81), 'path': '/iot-registration'},
    'share': {'label': '그린 쉐어', 'icon': Icons.volunteer_activism_outlined, 'color': Color(0xFFFD9644), 'path': '/share'},
    'visitor': {'label': '방문 차량', 'icon': Icons.directions_car_filled_outlined, 'color': Color(0xFF4B7BEC), 'path': '/center?tab=0'},
    'vote': {'label': '전자 투표', 'icon': Icons.how_to_vote_outlined, 'color': Color(0xFFEB3B5A), 'path': '/center?tab=1'},
  };

  void _showGroupDetail(BuildContext context, WidgetRef ref, MenuEntry group) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppTheme.navyDark.withOpacity(0.95),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          border: Border.all(color: AppTheme.glassBorder),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: AppTheme.textLow, borderRadius: BorderRadius.circular(2.r))),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(group.title ?? '그룹', style: TextStyle(fontFamily: 'Paperlogy', fontSize: 20.sp, fontWeight: FontWeight.w500, color: AppTheme.textHigh)),
                  IconButton(icon: Icon(Icons.close, color: AppTheme.textLow, size: 24.sp), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 24.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 0.8,
                ),
                itemCount: group.itemIds.length,
                itemBuilder: (context, index) {
                  final id = group.itemIds[index];
                  final data = menuData[id];
                  if (data == null) return const SizedBox.shrink();
                  
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.go(data['path']);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: (data['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: (data['color'] as Color).withOpacity(0.3)),
                          ),
                          child: Icon(data['icon'], color: data['color'], size: 28.sp),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          data['label'], 
                          style: TextStyle(fontFamily: 'Paperlogy', fontSize: 13.sp, color: AppTheme.textMedium),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupDialog(BuildContext context, WidgetRef ref, MenuEntry group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.navyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('그룹 관리', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 18.sp)),
        content: Text('이 그룹을 해제하시겠습니까?\n내부 아이템들은 각각의 카드로 돌아갑니다.', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 14.sp)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('취소', style: TextStyle(color: AppTheme.textLow))),
          TextButton(
            onPressed: () {
              ref.read(menuOrderProvider.notifier).ungroup(group.id);
              Navigator.pop(context);
            },
            child: Text('그룹 해제', style: TextStyle(color: AppTheme.alertRed, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuOrder = ref.watch(menuOrderProvider);

    final List<Widget> menuItems = menuOrder.asMap().entries.map((entry) {
      final index = entry.key;
      final menuEntry = entry.value;

      Widget getTile() {
        if (!menuEntry.isGroup) {
          final data = menuData[menuEntry.id];
          if (data == null) return const SizedBox.shrink();
          
          return HomeMenuTile(
            key: ValueKey(menuEntry.id),
            label: data['label'],
            icon: data['icon'],
            iconColor: data['color'],
            onTap: () => context.go(data['path']),
          );
        } else {
          return GroupCard(
            key: ValueKey(menuEntry.id),
            title: menuEntry.title ?? '그룹',
            icons: menuEntry.itemIds.map((id) => (menuData[id]?['icon'] as IconData? ?? Icons.help_outline)).toList(),
            onTap: () => _showGroupDetail(context, ref, menuEntry),
            onLongPress: () => _showGroupDialog(context, ref, menuEntry),
          );
        }
      }

      return DragTarget<int>(
        key: ValueKey(menuEntry.id),
        onWillAccept: (fromIndex) => fromIndex != index,
        onAccept: (fromIndex) {
          ref.read(menuOrderProvider.notifier).merge(fromIndex, index);
        },
        builder: (context, candidateData, rejectedData) {
          bool isHighlighted = candidateData.isNotEmpty;
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isHighlighted ? 0.6 : 1.0,
            child: LongPressDraggable<int>(
              data: index,
              feedback: Material(
                color: Colors.transparent,
                child: SizedBox(
                   width: 160.w,
                   child: getTile(),
                ),
              ),
              childWhenDragging: Opacity(opacity: 0.2, child: getTile()),
              child: getTile(),
            ),
          );
        },
      );
    }).toList();

    return ResidentHomeTemplate(
      header: _buildHeader(context),
      onRefresh: () async {
        ref.invalidate(energyHistoryProvider);
        ref.invalidate(energyCoachProvider);
        ref.invalidate(resident_living.visitorsProvider);
        ref.invalidate(resident_living.activeVotesProvider);
        ref.invalidate(resident_living.challengesProvider);
        ref.invalidate(resident_living.facilitiesProvider);
        ref.invalidate(resident_living.evChargersProvider);
        ref.invalidate(resident_living.deliveriesProvider);
        ref.invalidate(resident_living.shareItemsProvider);
        ref.invalidate(resident_living.talentExchangeProvider);
        ref.invalidate(resident_living.socialClubsProvider);
        ref.invalidate(homeEquipmentsProvider);
        ref.invalidate(gardenStatusProvider);
      },
      onReorder: (oldIndex, newIndex) {
        ref.read(menuOrderProvider.notifier).reorder(oldIndex, newIndex);
      },
      menuItems: menuItems,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.accentMint.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.face_retouching_natural_rounded, color: AppTheme.accentMint, size: 34.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning, Resident',
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textHigh,
                      letterSpacing: -0.5.w,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Your personalized AI coach is ready.',
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.accentMint.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
