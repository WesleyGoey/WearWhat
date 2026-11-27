import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../app/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/frames.dart';
import '../../widgets/headers.dart';
import '../../widgets/live_camera.dart';


class AddClothesPhotoScreen extends StatefulWidget {
  const AddClothesPhotoScreen({super.key});


  @override
  State<AddClothesPhotoScreen> createState() => _AddClothesPhotoScreenState();
}


class _AddClothesPhotoScreenState extends State<AddClothesPhotoScreen> {
  final _camera = GlobalKey<LiveCameraState>();
  bool _flash = false;


  /// Ambil foto dari pratinjau kamera, atau pilih dari galeri.
  /// Hasilnya dikirim ke layar Review.
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
      Navigator.pushNamed(context, Routes.addClothesReview, arguments: bytes);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not take the photo. Try again.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BackHeader(
              title: 'Add Clothes',
              trailing: CircleIconButton(
                icon: _flash ? Icons.flash_on : Icons.flash_off,
                tooltip: 'Flash',
                onPressed: () async {
                  final on = await _camera.currentState?.toggleFlash();
                  if (on != null) setState(() => _flash = on);
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: CameraFrame(
                  caption: 'Place one item on a plain background',
                  child: LiveCamera(key: _camera),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CameraControls(
              onShutter: _capture,
              onGallery: () => _capture(gallery: true),
              onFlip: () => _camera.currentState?.flip(),
            ),
            const SizedBox(height: 12),
            Text(
              'Tip: lay the item flat in good light',
              style: AppText.body(12, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
