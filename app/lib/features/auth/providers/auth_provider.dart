import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? role;
  final bool isLoading;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.role,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? role,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      role: role ?? this.role,
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
    try {
      final token = await _repository.login(email, password);
      if (token != null) {
        final userInfo = await _repository.getUserInfo();
        if (userInfo != null) {
          state = state.copyWith(
            isAuthenticated: true,
            token: token,
            role: userInfo['role'],
            isLoading: false,
          );
          return true;
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
