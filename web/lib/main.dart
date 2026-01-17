import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/router/admin_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: GreenBeeAdminApp(),
    ),
  );
}

class GreenBeeAdminApp extends StatelessWidget {
  const GreenBeeAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Strictly optimized for Web Admin (Desktop)
      designSize: const Size(1440, 900),
      minTextAdapt: false,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'GreenBee Admin Control',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: adminRouter,
        );
      },
    );
  }
}
