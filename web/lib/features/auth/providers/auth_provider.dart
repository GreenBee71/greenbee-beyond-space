import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? role;
  final String? globalRole;
  final bool isLoading;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.role,
    this.globalRole,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? role,
    String? globalRole,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      role: role ?? this.role,
      globalRole: globalRole ?? this.globalRole,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    // Explicitly block resident accounts on Web/Admin portal
    if (email.toLowerCase().contains('resident')) {
      state = state.copyWith(
        isLoading: false,
        error: '입주민 계정은 관리자 포털에 접속할 수 없습니다.',
      );
      return false;
    }

    try {
      final token = await _repository.login(email, password);
      if (token != null) {
        final userInfo = await _repository.getUserInfo();
        if (userInfo != null) {
          final globalRole = userInfo['global_role'];
          // Admin Web only allows Admin roles
          if (globalRole == 'MASTER_ADMIN' || globalRole == 'ADMIN') {
            state = state.copyWith(
              isAuthenticated: true,
              token: token,
              role: userInfo['role'],
              globalRole: globalRole,
              isLoading: false,
            );
            return true;
          } else {
            await _repository.logout();
            state = state.copyWith(
              isLoading: false,
              error: '관리자 권한이 없습니다.',
            );
            return false;
          }
        }
        state = state.copyWith(isLoading: false, error: '사용자 정보를 불러오는데 실패했습니다.');
        return false;
      }
      state = state.copyWith(isLoading: false, error: '이메일 또는 비밀번호를 확인해주세요.');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '로그인 중 오류가 발생했습니다.');
      return false;
    }
  }

  Future<void> checkInit() async {
    final token = await _repository.getToken();
    if (token != null) {
      final userInfo = await _repository.getUserInfo();
      if (userInfo != null) {
        state = state.copyWith(
          isAuthenticated: true,
          token: token,
          role: userInfo['role'],
          globalRole: userInfo['global_role'],
        );
      }
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
