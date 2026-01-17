import 'package:flutter/material.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';
import 'package:greenbee_web/core/widgets/atoms/glass_container.dart';

class BrandCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const BrandCard({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.accentMint : Colors.transparent,
            width: 2,
          ),
        ),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? AppTheme.accentMint : AppTheme.textHigh,
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: TextStyle(fontFamily: 'Paperlogy', 
                  color: isSelected ? AppTheme.accentMint : AppTheme.textHigh,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
