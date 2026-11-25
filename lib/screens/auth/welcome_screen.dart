import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/clothing_art.dart';
import '../../widgets/headers.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    // Kartu dekorasi memakai data contoh, karena user belum login di layar ini.
    final items = dummyItems();
    final outfits = dummyOutfits();
    List<ClothingItem> itemsOf(Outfit o) => [
      for (final c in ClothingCategory.values)
        if (o.items[c] != null) items.firstWhere((i) => i.id == o.items[c]),
    ];


    Widget card(int outfit, double angle, Offset offset, {bool front = false}) {
      return Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: angle,
          child: SizedBox(
            width: front ? 140 : 130,
            height: front ? 190 : 175,
            child: PaperCard(
              radius: 18,
              child: OutfitArt(
                items: itemsOf(outfits[outfit]),
                height: front ? 170 : 150,
              ),
            ),
          ),
        ),
      );
    }


    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0, .1),
            colors: [AppColors.gold, AppColors.bgBase],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                SizedBox(
                  height: 230,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      card(1, -.18, const Offset(-70, 16)),
                      card(2, .18, const Offset(70, 16)),
                      card(0, 0, Offset.zero, front: true),
                      const Positioned(
                        right: 60,
                        bottom: 12,
                        child: InfoChip(
                          label: 'AI pick',
                          icon: Icons.auto_awesome,
                          highlight: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const WearWhatLogo(size: 44),
                const SizedBox(height: 10),
                Text(
                  'Your AI stylist & wardrobe planner, dressed for the day, every day.',
                  textAlign: TextAlign.center,
                  style: AppText.body(14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    InfoChip(label: 'AI picks', icon: Icons.auto_awesome),
                    InfoChip(
                      label: 'Weather-aware',
                      icon: Icons.wb_sunny_outlined,
                    ),
                    InfoChip(
                      label: 'Planner',
                      icon: Icons.calendar_today_outlined,
                    ),
                  ],
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Sign Up',
                  onPressed: () => Navigator.pushNamed(context, Routes.signup),
                ),
                const SizedBox(height: 12),
                OutlineGoldButton(
                  label: 'Log In',
                  onPressed: () => Navigator.pushNamed(context, Routes.login),
                ),
                const SizedBox(height: 16),
                Text(
                  'By continuing, you agree to our Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: AppText.body(11, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
