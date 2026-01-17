import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/router/resident_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: GreenBeeResidentApp(),
    ),
  );
}

class GreenBeeResidentApp extends StatelessWidget {
  const GreenBeeResidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Strictly fixed for Mobile App (Resident)
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'GreenBee Beyond Space',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: residentRouter,
        );
      },
    );
  }
}
