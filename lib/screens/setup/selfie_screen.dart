import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../app/routes.dart';
import '../../widgets/chips.dart';
import '../../widgets/frames.dart';
import '../../widgets/headers.dart';
import '../../widgets/live_camera.dart';


/// Kamera selfie. Dibuka dari onboarding, atau dari Edit Profile
/// dengan arguments {'retake': true} supaya setelah foto kembali ke Edit Profile.
class SelfieScreen extends StatefulWidget {
  const SelfieScreen({super.key});


  @override
  State<SelfieScreen> createState() => _SelfieScreenState();
}


class _SelfieScreenState extends State<SelfieScreen> {
  final _camera = GlobalKey<LiveCameraState>();


  /// Ambil selfie dari pratinjau kamera depan (atau pilih dari galeri),
  /// lalu lanjut ke langkah berikutnya.
  // shortcut: foto tidak disimpan; skin tone tetap dipilih manual sampai
  // AI skin tone (S3) ada.
  Future<void> _capture({bool gallery = false}) async {
    try {
      Uint8List? bytes;
      if (gallery) {
        final file = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 1080,
          imageQuality: 80,
        );
        bytes = await file?.readAsBytes();
      } else {
        bytes = await _camera.currentState?.takePicture();
      }
      if (bytes == null || !mounted) return; // batal atau kamera belum siap
      _done();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not take the photo. Try again.')),
      );
    }
  }


  void _done() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['retake'] == true) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(const SnackBar(content: Text('Selfie updated.')));
    } else {
      Navigator.pushNamed(context, Routes.skinTone);
    }
  }


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final retake = args is Map && args['retake'] == true;


    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            retake
                ? const BackHeader(title: 'Retake selfie')
                : const StepHeader(step: 2),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: ScreenTitle(
                eyebrow: 'Step 2 of 3',
                title: 'Take a selfie',
                subtitle: 'Your face helps the AI calibrate colours that suit you.',
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CameraFrame(
                  caption: 'Fit your face inside the oval',
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LiveCamera(key: _camera, front: true),
                      const IgnorePointer(
                        child: DashedBox(
                          oval: true,
                          color: Color(0xFFD9B26A),
                          child: SizedBox(width: 150, height: 195),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CameraControls(
              onShutter: _capture,
              onGallery: () => _capture(gallery: true),
              onFlip: () => _camera.currentState?.flip(),
            ),
            const SizedBox(height: 16),
            const Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                InfoChip(label: 'Good light', icon: Icons.wb_sunny_outlined),
                InfoChip(label: 'No glasses', icon: Icons.close),
                InfoChip(label: 'Face forward', icon: Icons.person_outline),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
