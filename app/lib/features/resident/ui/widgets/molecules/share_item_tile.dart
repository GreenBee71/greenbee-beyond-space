import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class ShareItemTile extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String imageUrl;

  const ShareItemTile({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 120,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.handyman_outlined, color: AppTheme.textLow, size: 32),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 12, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '$price | $category',
            style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
