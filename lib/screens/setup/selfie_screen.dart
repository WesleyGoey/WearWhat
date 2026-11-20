import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../widgets/chips.dart';
import '../../widgets/frames.dart';
import '../../widgets/headers.dart';


/// Kamera selfie. Dibuka dari onboarding, atau dari Edit Profile
/// dengan arguments {'retake': true} supaya setelah foto kembali ke Edit Profile.
class SelfieScreen extends StatelessWidget {
  const SelfieScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final retake = args is Map && args['retake'] == true;
    final tone = AppState.instance.user.skinTone;


    void soon() => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera access is coming soon.')),
    );


    // shortcut: foto belum diambil sungguhan; AI skin tone (S3) belum ada.
    void capture() {
      if (retake) {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.pop(context);
        messenger.showSnackBar(
          const SnackBar(content: Text('Selfie updated.')),
        );
      } else {
        Navigator.pushNamed(context, Routes.skinTone);
      }
    }


    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            retake
                ? const BackHeader(title: 'Retake selfie')
                : const StepHeader(step: 2),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                children: [
                  const ScreenTitle(
                    eyebrow: 'Step 2 of 3',
                    title: 'Take a selfie',
                    subtitle: 'Your face helps the AI calibrate colours that suit you.',
                  ),
                  const SizedBox(height: 20),
                  CameraFrame(
                    caption: 'Fit your face inside the oval',
                    child: DashedBox(
                      oval: true,
                      color: const Color(0xFFD9B26A),
                      child: SizedBox(
                        width: 150,
                        height: 195,
                        child: Icon(
                          Icons.face,
                          size: 120,
                          color: skinTones[tone].color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CameraControls(
                    onShutter: capture,
                    onGallery: soon,
                    onFlip: soon,
                  ),
                  const SizedBox(height: 20),
                  const Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      InfoChip(
                        label: 'Good light',
                        icon: Icons.wb_sunny_outlined,
                      ),
                      InfoChip(label: 'No glasses', icon: Icons.close),
                      InfoChip(
                        label: 'Face forward',
                        icon: Icons.person_outline,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
