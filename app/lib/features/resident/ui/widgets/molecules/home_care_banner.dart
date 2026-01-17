import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class HomeCareBanner extends StatelessWidget {
  final VoidCallback onTap;

  const HomeCareBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.vpn_key_outlined, color: Colors.amberAccent, size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Safe Home Premium Care', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Leave your home safely while you\'re away.', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textLow),
          ],
        ),
      ),
    );
  }
}
