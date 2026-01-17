import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/organisms/visitor_tab_content.dart';
import '../widgets/organisms/vote_tab_content.dart';
import '../widgets/organisms/search_tab_content.dart';

class LivingSupportPage extends ConsumerWidget {
  final int initialIndex;
  const LivingSupportPage({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('생활 지원'),
          bottom: const TabBar(
            indicatorColor: AppTheme.accentMint,
            tabs: [
              Tab(text: '방문 차량'),
              Tab(text: '전자 투표'),
              Tab(text: 'AI 검색'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VisitorTabContent(),
            VoteTabContent(),
            SearchTabContent(),
          ],
        ),
      ),
    );
  }
}
