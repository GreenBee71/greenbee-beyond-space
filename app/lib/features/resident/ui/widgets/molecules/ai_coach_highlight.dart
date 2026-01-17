import 'package:flutter/material.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/core/widgets/atoms/glass_container.dart';

class AiCoachHighlight extends StatelessWidget {
  final int score;
  final String summary;
  final VoidCallback onTap;

  const AiCoachHighlight({
    super.key,
    required this.score,
    required this.summary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            _buildScoreSmall(score),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI 코치 한마디', 
                    style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontSize: 12, fontWeight: FontWeight.w500)
                  ),
                  const SizedBox(height: 4),
                  Text(
                    summary,
                    style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSmall(int score) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.accentMint.withOpacity(0.5), width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$score',
        style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
