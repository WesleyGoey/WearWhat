import 'package:flutter/material.dart';


import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav.dart';


/// Coach-mark pertama kali masuk Home: "Tap + to add".
/// Menutupi seluruh layar; tombol + disorot di posisi yang sama dengan bottom nav.
class HomeTutorial extends StatelessWidget {
  const HomeTutorial({super.key, required this.onDone, required this.onAdd});


  final VoidCallback onDone;
  final VoidCallback onAdd;


  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.paddingOf(context).bottom;
    // Tombol + di bottom nav menempel di atas bar; tinggi area nav = AppBottomNav.height.
    final addBottom = inset + AppBottomNav.height - AppBottomNav.addSize;


    return Material(
      color: Colors.black.withValues(alpha: .72),
      child: Stack(
        children: [
          Positioned(
            left: 32,
            right: 32,
            bottom: addBottom + AppBottomNav.addSize + 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.gold),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TIP', style: AppText.eyebrow),
                  const SizedBox(height: 6),
                  Text('Tap + to add', style: AppText.display(22)),
                  const SizedBox(height: 4),
                  Text(
                    'Add a clothing item or create an outfit from here.',
                    style: AppText.body(12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: onDone,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.bgBase,
                      ),
                      child: const Text('Got it'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: addBottom - 6,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                child: AddButton(
                  onPressed: () {
                    onDone();
                    onAdd();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
