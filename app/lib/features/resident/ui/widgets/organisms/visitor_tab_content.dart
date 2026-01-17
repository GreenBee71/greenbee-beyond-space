import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/atoms/neon_button.dart';
import '../../../../../core/widgets/organisms/visitor_card.dart';
import '../../../providers/living_provider.dart';

class VisitorTabContent extends ConsumerWidget {
  const VisitorTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitorsAsync = ref.watch(visitorsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVisitorDialog(context, ref),
        label: const Text('차량 등록'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.accentMint,
        foregroundColor: Colors.black,
      ),
      body: visitorsAsync.when(
        data: (visitors) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: visitors.length,
          itemBuilder: (context, index) => VisitorCard(visitor: visitors[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showAddVisitorDialog(BuildContext context, WidgetRef ref) {
    final carController = TextEditingController();
    final nameController = TextEditingController();
    final purposeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('방문 차량 등록', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: carController, 
              style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white),
              decoration: const InputDecoration(labelText: '차량 번호', labelStyle: TextStyle(fontFamily: 'Paperlogy', color: Colors.white70)),
            ),
            TextField(
              controller: nameController, 
              style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white),
              decoration: const InputDecoration(labelText: '방문객 성함', labelStyle: TextStyle(fontFamily: 'Paperlogy', color: Colors.white70)),
            ),
            TextField(
              controller: purposeController, 
              style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white),
              decoration: const InputDecoration(labelText: '방문 목적', labelStyle: TextStyle(fontFamily: 'Paperlogy', color: Colors.white70)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('취소', style: TextStyle(fontFamily: 'Paperlogy', color: Colors.white54)),
          ),
          NeonButton(
            label: '등록',
            onPressed: () async {
              await ref.read(livingRepositoryProvider).createVisitor(
                carController.text,
                nameController.text,
                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                purposeController.text,
              );
              ref.invalidate(visitorsProvider);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
