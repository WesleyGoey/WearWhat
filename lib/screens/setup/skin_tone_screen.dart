import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headers.dart';
import '../../widgets/profile_pickers.dart';


class SkinToneScreen extends StatefulWidget {
  const SkinToneScreen({super.key});


  @override
  State<SkinToneScreen> createState() => _SkinToneScreenState();
}


class _SkinToneScreenState extends State<SkinToneScreen> {
  int _tone = AppState.instance.user.skinTone;


  void _finish() {
    final state = AppState.instance;
    final u = state.user;
    state.updateUser(
      UserProfile(name: u.name, age: u.age, gender: u.gender, skinTone: _tone),
    );
    state.finishOnboarding();
    Navigator.pushNamedAndRemoveUntil(context, Routes.main, (_) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StepHeader(step: 3),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                children: [
                  const ScreenTitle(
                    eyebrow: 'Step 3 of 3',
                    title: 'Your skin tone',
                    subtitle: 'Pick the tone closest to yours so colours flatter you.',
                  ),
                  const SizedBox(height: 20),
                  Center(child: SelfieAvatar(tone: _tone)),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'Your selfie',
                      style: AppText.body(12, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SkinTonePicker(
                    selected: _tone,
                    onChanged: (i) => setState(() => _tone = i),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.goldTint,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.goldDark),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: AppColors.gold,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'AI uses your tone to suggest colours that flatter you.',
                            style: AppText.body(13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: PrimaryButton(label: 'Finish Setup', onPressed: _finish),
            ),
          ],
        ),
      ),
    );
  }
}
