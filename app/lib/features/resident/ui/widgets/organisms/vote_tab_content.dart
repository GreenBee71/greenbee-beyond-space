import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/widgets/organisms/vote_card.dart';
import '../../../providers/living_provider.dart';

class VoteTabContent extends ConsumerWidget {
  const VoteTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final votesAsync = ref.watch(activeVotesProvider);

    return votesAsync.when(
      data: (votes) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: votes.length,
        itemBuilder: (context, index) => VoteCard(
          vote: votes[index],
          onVote: (val) {
            // TODO: Implement voting logic
          },
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
