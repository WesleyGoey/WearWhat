import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../app/routes.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/clothing_art.dart';
import '../../widgets/frames.dart';
import '../../widgets/headers.dart';


class AddClothesPhotoScreen extends StatefulWidget {
  const AddClothesPhotoScreen({super.key});


  @override
  State<AddClothesPhotoScreen> createState() => _AddClothesPhotoScreenState();
}


class _AddClothesPhotoScreenState extends State<AddClothesPhotoScreen> {
  bool _flash = false;
  bool _front = false;


  /// Buka kamera atau galeri HP, lalu kirim fotonya ke layar Review.
  Future<void> _pick(ImageSource source) async {
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1080,
        imageQuality: 80,
        preferredCameraDevice: _front ? CameraDevice.front : CameraDevice.rear,
      );
      if (file == null) return; // user batal
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      Navigator.pushNamed(context, Routes.addClothesReview, arguments: bytes);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the camera. Check app permissions.'),
        ),
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
                onPressed: () => setState(() => _flash = !_flash),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                children: [
                  const CameraFrame(
                    height: 380,
                    caption: 'Place one item on a plain background',
                    child: ClothingArt(
                      category: ClothingCategory.top,
                      color: AppColors.paper,
                      size: 190,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CameraControls(
                    onShutter: () => _pick(ImageSource.camera),
                    onGallery: () => _pick(ImageSource.gallery),
                    onFlip: () => setState(() => _front = !_front),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Tip: lay the item flat in good light',
                      style: AppText.body(12, color: AppColors.textTertiary),
                    ),
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
