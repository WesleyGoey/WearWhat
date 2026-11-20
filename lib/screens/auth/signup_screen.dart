import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headers.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});


  @override
  State<SignupScreen> createState() => _SignupScreenState();
}


class _SignupScreenState extends State<SignupScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();


  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }


  // shortcut: belum ada pendaftaran sungguhan; sambungkan ke backend setelah S2-03.
  void _createAccount() {
    String? error;
    if (!_email.text.contains('@')) {
      error = 'Enter a valid email.';
    } else if (_password.text.length < 8) {
      error = 'Password needs at least 8 characters.';
    } else if (_password.text != _confirm.text) {
      error = 'Passwords do not match.';
    }
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.pushNamed(context, Routes.basicInfo);
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
                      eyebrow: 'Create account',
                      title: 'Sign up',
                      subtitle:
                          'Create an account to start building your wardrobe.',
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Email',
                      controller: _email,
                      hint: 'alex@email.com',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Password',
                      controller: _password,
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Confirm Password',
                      controller: _confirm,
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Create Account',
                      onPressed: _createAccount,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.borderSubtle),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or sign up with',
                            style: AppText.body(
                              11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.borderSubtle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SecondaryButton(
                      label: 'Sign up with Google',
                      leading: CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.textPrimary,
                        child: Text(
                          'G',
                          style: AppText.body(
                            12,
                            weight: FontWeight.w700,
                            color: AppColors.bgBase,
                          ),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.basicInfo),
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        style: AppText.body(11, color: AppColors.textTertiary),
                        children: [
                          const TextSpan(
                            text: 'By signing up, you agree to the ',
                          ),
                          TextSpan(
                            text: 'Terms of Service',
                            style: AppText.body(11, color: AppColors.gold),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: AppText.body(11, color: AppColors.gold),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppText.body(
                            13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            Routes.login,
                          ),
                          child: Text(
                            'Log In',
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
