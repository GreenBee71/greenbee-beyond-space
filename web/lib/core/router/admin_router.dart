import 'package:go_router/go_router.dart';
import '../../features/auth/ui/pages/login_page.dart';
import '../../features/admin/ui/pages/admin_shell_page.dart';
import '../../features/admin/ui/pages/admin_overview_page.dart';
import '../../features/admin/ui/pages/admin_visitor_management_page.dart';
import '../../features/admin/ui/pages/admin_user_verification_page.dart';
import '../../features/admin/ui/pages/master_admin_dashboard_page.dart';
import '../../features/admin/ui/pages/master_complex_management_page.dart';
import '../../features/admin/ui/pages/master_user_management_page.dart';
import '../../features/admin/ui/pages/master_announcement_page.dart';

final adminRouter = GoRouter(
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
      builder: (context, state, child) => AdminShellPage(child: child, location: state.matchedLocation),
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminOverviewPage(),
        ),
        GoRoute(
          path: '/admin/visitors',
          builder: (context, state) => const AdminVisitorManagementPage(),
        ),
        GoRoute(
          path: '/admin/users',
          builder: (context, state) => const AdminUserVerificationPage(),
        ),
        GoRoute(
          path: '/admin/master',
          builder: (context, state) => const MasterAdminDashboardPage(),
        ),
        GoRoute(
          path: '/admin/master/complexes',
          builder: (context, state) => const MasterComplexManagementPage(),
        ),
        GoRoute(
          path: '/admin/master/users',
          builder: (context, state) => const MasterUserManagementPage(),
        ),
        GoRoute(
          path: '/admin/master/announcements',
          builder: (context, state) => const MasterAnnouncementPage(),
        ),
      ],
    ),
  ],
);
