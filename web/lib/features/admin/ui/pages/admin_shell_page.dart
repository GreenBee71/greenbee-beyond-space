import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/providers/auth_provider.dart';
import '../templates/admin_shell_template.dart';

class AdminShellPage extends ConsumerWidget {
  final Widget child;
  final String location;
  const AdminShellPage({super.key, required this.child, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = 0;
    // Determine selected index based on path
    if (location.startsWith('/admin/visitors')) {
      selectedIndex = 1;
    } else if (location.startsWith('/admin/users')) {
      selectedIndex = 2;
    } else if (location.startsWith('/admin/master/complexes') || 
               location.startsWith('/admin/master/settings')) {
      // Sub-pages of master go to "System Settings" (Index 3)
      selectedIndex = 3;
    } else if (location.startsWith('/admin/master')) {
      // Main Master Dashboard -> "Operation Dashboard" (Index 0)
      selectedIndex = 0;
    }

    return AdminShellTemplate(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        final authState = ref.read(authStateProvider);
        final isMaster = authState.globalRole == 'MASTER_ADMIN';

        switch (index) {
          case 0: // Operation Dashboard
            if (isMaster) {
              context.go('/admin/master');
            } else {
              context.go('/admin');
            }
            break;
          case 1: context.go('/admin/visitors'); break;
          case 2: context.go('/admin/users'); break;
          case 3: 
             // System Settings
             if (isMaster) {
               // Master Settings Entry Point
               context.go('/admin/master/complexes'); 
             } else {
               // Normal Admin Settings fallback
               context.go('/admin/settings'); 
             }
             break;
        }
      },
      onLogout: () {
        ref.read(authStateProvider.notifier).logout();
        context.go('/');
      },
      child: child,
    );
  }
}
