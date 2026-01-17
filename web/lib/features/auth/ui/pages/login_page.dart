import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final _emailController = TextEditingController(text: 'admin@greenbee.com');
  final _passwordController = TextEditingController(text: 'admin123');

  Future<void> _handleLogin() async {
    final success = await ref.read(authStateProvider.notifier).login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      final authState = ref.read(authStateProvider);
      if (authState.globalRole == 'MASTER_ADMIN') {
        context.go('/admin/master');
      } else {
        context.go('/admin');
      }
    } else if (mounted) {
      final error = ref.read(authStateProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? '관리자 로그인에 실패했습니다.'),
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
            label: '관리자 계정',
            prefixIcon: const Icon(Icons.admin_panel_settings_outlined, color: AppTheme.accentMint, size: 20),
          ),
          style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 20.sp),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: AppTheme.glassInputDecoration(
            label: '마스터 비밀번호',
            prefixIcon: const Icon(Icons.vpn_key_outlined, color: AppTheme.accentMint, size: 20),
          ),
          style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh, fontSize: 20.sp),
        ),
      ],
      loginButton: authState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentMint))
          : NeonButton(
              label: '시스템 관리실 접속',
              onPressed: _handleLogin,
            ),
      helperButtons: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHelperButton('일반 관리자', () {
                setState(() {
                  _emailController.text = 'admin@greenbee.com';
                  _passwordController.text = 'admin123';
                });
              }),
              Container(
                width: 1,
                height: 12,
                color: Colors.white24,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              _buildHelperButton('시스템 마스터', () {
                setState(() {
                  _emailController.text = 'master@greenbee.com';
                  _passwordController.text = 'master123';
                });
              }),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'AUTHORIZED PERSONNEL ONLY',
            style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.alertRed, fontSize: 20, letterSpacing: 1.2, fontWeight: FontWeight.w500),
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
        style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textLow, fontSize: 20, fontWeight: FontWeight.w400),
      ),
    );
  }
}
