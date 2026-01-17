import '../../theme/app_theme.dart';
import '../../models/vote.dart';

class VoteCard extends StatelessWidget {
  final Vote vote;
  final Function(String?) onVote;

  const VoteCard({super.key, required this.vote, required this.onVote});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.navyMedium.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(vote.title, style: const TextStyle(fontFamily: 'Paperlogy', fontWeight: FontWeight.w500, fontSize: 16)),
            subtitle: Text('종료일: ${vote.endDate.split('T')[0]}', style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(vote.description, style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium)),
          ),
          ...vote.options.map((option) => RadioListTile<String>(
            title: Text(option, style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white)),
            value: option,
            groupValue: null,
            activeColor: AppTheme.accentMint,
            onChanged: onVote,
          )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
