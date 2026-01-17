import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenbee_app/core/theme/app_theme.dart';
import 'package:greenbee_app/features/resident/providers/living_provider.dart';

class SearchTabContent extends ConsumerWidget {
  const SearchTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultsAsync = ref.watch(searchResultsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: '단지 내 궁금한 것을 물어보세요 (예: 헬스장 시간)',
              prefixIcon: const Icon(Icons.search, color: AppTheme.accentMint),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
        ),
        Expanded(
          child: searchResultsAsync.when(
            data: (results) {
              if (results.isEmpty) {
                return const Center(
                  child: Text('검색 결과가 없습니다.', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white54)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return Card(
                    color: Colors.white.withOpacity(0.05),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(result.title, style: const TextStyle(fontFamily: 'Paperlogy', fontWeight: FontWeight.w500)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(result.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentMint.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(result.category, style: const TextStyle(fontFamily: 'Paperlogy', fontSize: 12, color: AppTheme.accentMint)),
                              ),
                              const Spacer(),
                              Text('유사도 ${(result.score * 100).toStringAsFixed(1)}%', style: const TextStyle(fontFamily: 'Paperlogy', fontSize: 12, color: Colors.white38)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}
