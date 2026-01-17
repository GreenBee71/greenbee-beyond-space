import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/admin_repository.dart';
import '../../../core/models/visitor.dart';
import '../../auth/providers/auth_provider.dart';

final adminRepositoryProvider = Provider((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AdminRepository(authRepo);
});

final unverifiedUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.getUnverifiedUsers();
});

final allVisitorsProvider = FutureProvider<List<Visitor>>((ref) async {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.getAllVisitors();
});
