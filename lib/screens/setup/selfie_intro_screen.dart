import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headers.dart';


/// Layar baru hasil usability testing: menjelaskan alasan selfie sebelum kamera.
class SelfieIntroScreen extends StatelessWidget {
  const SelfieIntroScreen({super.key});


  static const _points = [
    ('Find your colours', 'Your skin tone helps AI pick shades that suit you.'),
    ('Quick tips', 'Good light, no glasses, face the camera.'),
    ('Your choice', 'Skip anytime and pick your skin tone by hand.'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StepHeader(step: 2),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                children: [
                  const ScreenTitle(
                    eyebrow: 'Step 2 of 3',
                    title: 'Why a selfie?',
                    subtitle: 'Takes about 5 seconds. The AI reads your skin tone so colour suggestions fit you.',
                  ),
                  const SizedBox(height: 28),
                  for (var i = 0; i < _points.length; i++)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.gold),
                            ),
                            child: Text(
                              '${i + 1}',
                              style: AppText.body(14, color: AppColors.gold),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _points[i].$1,
                                  style: AppText.body(
                                    15,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _points[i].$2,
                                  style: AppText.body(
                                    12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: PrimaryButton(
                label: 'Take selfie',
                onPressed: () => Navigator.pushNamed(context, Routes.selfie),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, Routes.skinTone),
              child: Text(
                'Skip, choose skin tone manually',
                style: AppText.body(
                  13,
                  weight: FontWeight.w500,
                  color: AppColors.gold,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
