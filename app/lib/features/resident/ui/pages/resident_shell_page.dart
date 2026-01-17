import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../templates/resident_shell_template.dart';

class ResidentShellPage extends StatelessWidget {
  final Widget child;
  final String location;

  const ResidentShellPage({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    if (location.startsWith('/home')) {
      selectedIndex = 0;
    } else if (location.startsWith('/beyond')) {
      selectedIndex = 1;
    } else if (location.startsWith('/support')) {
      selectedIndex = 2;
    } else if (location.startsWith('/connect')) {
      selectedIndex = 3;
    } else if (location.startsWith('/pass')) {
      selectedIndex = 4;
    }

    return ResidentShellTemplate(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/beyond');
            break;
          case 2:
            context.go('/support');
            break;
          case 3:
            context.go('/connect');
            break;
          case 4:
            context.go('/pass');
            break;
        }
      },
      child: child,
    );
  }
}
