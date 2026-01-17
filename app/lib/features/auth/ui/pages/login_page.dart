import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/atoms/neon_button.dart';
import '../../providers/auth_provider.dart';
import '../widgets/molecules/login_logo.dart';
import '../templates/login_template.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController(text: 'resident@greenbee.com');
  final _passwordController = TextEditingController(text: 'greenbee123');

  Future<void> _handleLogin() async {
    final success = await ref.read(authStateProvider.notifier).login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      // Resident App always goes to home
      context.go('/home');
    } else if (mounted) {
      final error = ref.read(authStateProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? '로그인에 실패했습니다.'),
          backgroundColor: AppTheme.alertRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return LoginTemplate(
      logo: const LoginLogo(),
      fields: [
        TextFormField(
          controller: _emailController,
          decoration: AppTheme.glassInputDecoration(
            label: '이메일 주소',
            prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.accentMint, size: 20),
          ),
          style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 14),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: AppTheme.glassInputDecoration(
            label: '비밀번호',
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppTheme.accentMint, size: 20),
          ),
          style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 14),
        ),
      ],
      loginButton: authState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentMint))
          : NeonButton(
              label: '공간 입장하기',
              onPressed: _handleLogin,
            ),
      helperButtons: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            '비밀번호를 잊으셨나요?',
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow.withOpacity(0.5), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperButton(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 12, fontWeight: FontWeight.w400),
      ),
    );
  }
}
