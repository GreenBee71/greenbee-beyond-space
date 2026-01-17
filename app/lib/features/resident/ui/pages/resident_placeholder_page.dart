import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ResidentPlaceholderPage extends StatelessWidget {
  final String title;
  const ResidentPlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: 'Paperlogy')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 64, color: AppTheme.accentMint.withOpacity(0.5)),
            const SizedBox(height: 24),
            Text(
              '$title 서비스 준비 중입니다',
              style: const TextStyle(
                fontFamily: 'Paperlogy',
                color: AppTheme.textMedium,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
