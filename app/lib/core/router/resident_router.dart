import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/ui/pages/login_page.dart';
import '../../features/resident/ui/pages/resident_home_page.dart';
import '../../features/resident/ui/pages/living_support_page.dart';
import '../../features/finance/ui/pages/finance_page.dart';
import '../../features/finance/ui/pages/greenpay_page.dart';
import '../../features/iot/ui/pages/iot_registration_page.dart';
import '../../features/resident/ui/pages/resident_shell_page.dart';
import '../../features/resident/ui/pages/resident_placeholder_page.dart';
import '../../features/resident/ui/pages/energy_challenge_page.dart';
import '../../features/resident/ui/pages/ev_smart_care_page.dart';
import '../../features/resident/ui/pages/doorstep_manager_page.dart';
import '../../features/resident/ui/pages/green_share_page.dart';
import '../../features/resident/ui/pages/community_live_hub_page.dart';
import '../../features/resident/ui/pages/hub_grid_page.dart';
import '../../features/resident/ui/widgets/molecules/home_menu_tile.dart';

final residentRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => ResidentShellPage(child: child, location: state.matchedLocation),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const ResidentHomePage(),
        ),
        GoRoute(
          path: '/beyond',
          builder: (context, state) => HubGridPage(
            title: 'Beyond',
            description: '에너지 가치와 스마트 환경',
            icon: Icons.explore_rounded,
            menuItems: [
              HomeMenuTile(key: const ValueKey('b1'), label: '에너지 관리', icon: Icons.bolt_rounded, onTap: () => context.go('/energy')),
              HomeMenuTile(key: const ValueKey('b2'), label: '전기차 충전', icon: Icons.ev_station_rounded, onTap: () => context.go('/ev')),
              HomeMenuTile(key: const ValueKey('b3'), label: '인피니트 가든', icon: Icons.eco_rounded, onTap: () => context.go('/iot-registration')),
            ],
          ),
        ),
        GoRoute(
          path: '/support',
          builder: (context, state) => HubGridPage(
            title: 'Support',
            description: '심리스한 일상 지원 서비스',
            icon: Icons.headset_mic_rounded,
            menuItems: [
              HomeMenuTile(key: const ValueKey('s1'), label: '스마트 택배', icon: Icons.inventory_2_outlined, onTap: () => context.go('/doorstep')),
              HomeMenuTile(key: const ValueKey('s2'), label: '세탁 서비스', icon: Icons.local_laundry_service_outlined, onTap: () => context.go('/doorstep?tab=1')),
              HomeMenuTile(key: const ValueKey('s3'), label: '홈 케어', icon: Icons.cleaning_services_outlined, onTap: () => context.go('/doorstep?tab=2')),
              HomeMenuTile(key: const ValueKey('s4'), label: '방문 차량', icon: Icons.directions_car_filled_outlined, onTap: () => context.go('/center?tab=0')),
            ],
          ),
        ),
        GoRoute(
          path: '/connect',
          builder: (context, state) => HubGridPage(
            title: 'Connect',
            description: '이웃과 함께하는 소셜 공간',
            icon: Icons.hub_rounded,
            menuItems: [
              HomeMenuTile(key: const ValueKey('c1'), label: '그린 쉐어', icon: Icons.volunteer_activism_outlined, onTap: () => context.go('/share')),
              HomeMenuTile(key: const ValueKey('c2'), label: '커뮤니티', icon: Icons.groups_2_rounded, onTap: () => context.go('/community-hub')),
              HomeMenuTile(key: const ValueKey('c3'), label: '전자 투표', icon: Icons.how_to_vote_outlined, onTap: () => context.go('/center?tab=1')),
              HomeMenuTile(key: const ValueKey('c4'), label: '공지사항', icon: Icons.notifications_none_rounded, onTap: () => context.go('/notices')),
            ],
          ),
        ),
        GoRoute(
          path: '/pass',
          builder: (context, state) => HubGridPage(
            title: 'Pass',
            description: '물리적 이동과 금융 실천',
            icon: Icons.qr_code_scanner_rounded,
            menuItems: [
              HomeMenuTile(key: const ValueKey('p1'), label: '그린페이', icon: Icons.account_balance_wallet_outlined, onTap: () => context.go('/finance/greenpay')),
              HomeMenuTile(key: const ValueKey('p2'), label: '출입 QR', icon: Icons.qr_code_2_rounded, onTap: () => {}),
              HomeMenuTile(key: const ValueKey('p3'), label: '엘리베이터 호출', icon: Icons.unfold_more_rounded, onTap: () => {}),
            ],
          ),
        ),
        GoRoute(
          path: '/notices',
          builder: (context, state) => const ResidentPlaceholderPage(title: '공지사항'),
        ),
        GoRoute(
          path: '/reservations',
          builder: (context, state) => const ResidentPlaceholderPage(title: '커뮤니티 예약'),
        ),
        GoRoute(
          path: '/center',
          builder: (context, state) {
            final tab = state.uri.queryParameters['tab'];
            final index = tab != null ? int.tryParse(tab) ?? 0 : 0;
            return LivingSupportPage(initialIndex: index);
          }
        ),
        GoRoute(
          path: '/my',
          builder: (context, state) => const ResidentPlaceholderPage(title: '마이 페이지'),
        ),
        // --- Feature Routes ---
        GoRoute(
          path: '/energy',
          builder: (context, state) => const EnergyChallengePage(),
        ),
        GoRoute(
          path: '/ev',
          builder: (context, state) => const EVSmartCarePage(),
        ),
        GoRoute(
          path: '/doorstep',
          builder: (context, state) {
            final tab = state.uri.queryParameters['tab'];
            final index = tab != null ? int.tryParse(tab) ?? 0 : 0;
            return DoorstepManagerPage(initialIndex: index);
          }
        ),
        GoRoute(
          path: '/community-hub',
          builder: (context, state) => const CommunityLiveHubPage(),
        ),
        GoRoute(
          path: '/share',
          builder: (context, state) => const GreenSharePage(),
        ),
        GoRoute(
          path: '/iot-registration',
          builder: (context, state) => const IotRegistrationPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/finance',
      builder: (context, state) => const FinancePage(),
      routes: [
        GoRoute(
          path: 'greenpay',
          builder: (context, state) => const GreenPayPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/living',
      builder: (context, state) {
        final tab = state.uri.queryParameters['tab'];
        final index = tab != null ? int.tryParse(tab) ?? 0 : 0;
        return LivingSupportPage(initialIndex: index);
      }
    ),
  ],
);
