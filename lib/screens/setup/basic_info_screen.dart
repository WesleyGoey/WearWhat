import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headers.dart';
import '../../widgets/profile_pickers.dart';


class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});


  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}


class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  Gender _gender = Gender.male;


  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    super.dispose();
  }


  void _next() {
    final age = int.tryParse(_age.text);
    if (_name.text.trim().isEmpty || age == null || age < 1 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill in your name and a valid age.')),
      );
      return;
    }
    final state = AppState.instance;
    state.updateUser(
      UserProfile(
        name: _name.text.trim(),
        age: age,
        gender: _gender,
        skinTone: state.user.skinTone,
      ),
    );
    Navigator.pushNamed(context, Routes.selfieIntro);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StepHeader(step: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenTitle(
                      eyebrow: 'Step 1 of 3',
                      title: 'Tell us about you',
                      subtitle: 'We use this to personalise every outfit the AI suggests.',
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Name',
                      controller: _name,
                      hint: 'Alex',
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Age',
                      controller: _age,
                      hint: '21',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gender',
                      style: AppText.body(13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    GenderSelector(
                      value: _gender,
                      onChanged: (g) => setState(() => _gender = g),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: PrimaryButton(label: 'Next', onPressed: _next),
            ),
          ],
        ),
      ),
    );
  }
}
