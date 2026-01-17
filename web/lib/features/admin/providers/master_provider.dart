import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../repositories/master_repository.dart';

final masterRepositoryProvider = Provider((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return MasterRepository(authRepo);
});

final globalStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(masterRepositoryProvider);
  return repo.getGlobalStats();
});

final iotStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(masterRepositoryProvider);
  return repo.getIoTStats();
});

final trendsStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(masterRepositoryProvider);
  return repo.getTrends();
});

final complexesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(masterRepositoryProvider);
  return repo.getComplexes();
});

final allUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(masterRepositoryProvider);
  return repo.getAllUsers();
});

final announcementsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(masterRepositoryProvider);
  return repo.getAnnouncements();
});

// Logic Layer: Notifier for handling Master Admin actions
class MasterAdminActionState {
  final bool isUploading;
  final String? error;
  final String? successMessage;

  MasterAdminActionState({
    this.isUploading = false,
    this.error,
    this.successMessage,
  });

  MasterAdminActionState copyWith({
    bool? isUploading,
    String? error,
    String? successMessage,
  }) {
    return MasterAdminActionState(
      isUploading: isUploading ?? this.isUploading,
      error: error,
      successMessage: successMessage,
    );
  }
}

class MasterAdminNotifier extends StateNotifier<MasterAdminActionState> {
  final MasterRepository _repo;
  final Ref _ref;

  MasterAdminNotifier(this._repo, this._ref) : super(MasterAdminActionState());

  Future<void> uploadBillings(String content, String fileName) async {
    state = state.copyWith(isUploading: true, error: null, successMessage: null);
    try {
      final message = await _repo.uploadBulkBillings(content, fileName);
      state = state.copyWith(isUploading: false, successMessage: message);
      // Refresh stats after successful upload
      _ref.invalidate(globalStatsProvider);
    } catch (e) {
      state = state.copyWith(isUploading: false, error: e.toString());
    }
  }

  void clearState() {
    state = MasterAdminActionState();
  }
}

final masterAdminActionProvider = StateNotifierProvider<MasterAdminNotifier, MasterAdminActionState>((ref) {
  final repo = ref.watch(masterRepositoryProvider);
  return MasterAdminNotifier(repo, ref);
});
