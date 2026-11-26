import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../app/session.dart';
import '../../data/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headers.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;


  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  void _showMessage(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));


  Future<void> _login() async {
    if (!_email.text.contains('@') || _password.text.isEmpty) {
      _showMessage('Enter a valid email and password.');
      return;
    }
    setState(() => _loading = true);
    final error = await AuthService.signIn(_email.text.trim(), _password.text);
    String? route;
    if (error == null) {
      try {
        route = await startSession();
      } catch (_) {
        route = null;
      }
    }
    if (!mounted) return;
    setState(() => _loading = false);
    if (error != null) return _showMessage(error);
    if (route == null) {
      return _showMessage('Could not load your data. Try again.');
    }
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(titleWidget: WearWhatLogo()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ScreenTitle(
                      eyebrow: 'Welcome back',
                      title: 'Log in',
                      subtitle:
                          'Log in to see your wardrobe and planned outfits.',
                    ),
                    const SizedBox(height: 28),
                    AppTextField(
                      label: 'Email',
                      controller: _email,
                      hint: 'alex@email.com',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Password',
                      controller: _password,
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            _showMessage('Password reset is coming soon.'),
                        child: Text(
                          'Forgot password?',
                          style: AppText.body(
                            12,
                            weight: FontWeight.w600,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      label: _loading ? 'Logging in...' : 'Log In',
                      onPressed: _loading ? null : _login,
                    ),
                    const SizedBox(height: 20),
                    const _OrDivider(text: 'or continue with'),
                    const SizedBox(height: 20),
                    SecondaryButton(
                      label: 'Continue with Google',
                      leading: const _GoogleMark(),
                      // shortcut: login Google belum diaktifkan di MVP.
                      onPressed: () =>
                          _showMessage('Google sign-in is coming soon.'),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppText.body(
                            13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            Routes.signup,
                          ),
                          child: Text(
                            'Sign Up',
                            style: AppText.body(
                              13,
                              weight: FontWeight.w600,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.text});


  final String text;


  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider(color: AppColors.borderSubtle)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          text,
          style: AppText.body(11, color: AppColors.textTertiary),
        ),
      ),
      const Expanded(child: Divider(color: AppColors.borderSubtle)),
    ],
  );
}


class _GoogleMark extends StatelessWidget {
  const _GoogleMark();


  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 10,
    backgroundColor: AppColors.textPrimary,
    child: Text(
      'G',
      style: AppText.body(12, weight: FontWeight.w700, color: AppColors.bgBase),
    ),
  );
}
