import 'package:flutter/material.dart';


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


  void _soon() => ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Camera access is coming soon.')),
  );


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
                    // shortcut: foto belum diambil sungguhan; tambah package camera di Sprint 3.
                    onShutter: () =>
                        Navigator.pushNamed(context, Routes.addClothesReview),
                    onGallery: _soon,
                    onFlip: _soon,
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
