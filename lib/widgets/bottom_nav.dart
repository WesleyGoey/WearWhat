import 'package:flutter/material.dart';


import '../theme/app_colors.dart';
import '../theme/app_theme.dart';


/// Bottom navigation: Home, Wardrobe, (+), Calendar, Profile.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.index,
    required this.onTap,
    required this.onAdd,
  });


  /// Tinggi total di atas safe area (bar 72 + tombol + yang menonjol 28).
  static const double height = 100;
  static const double addSize = 60;


  final int index;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;


  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.checkroom_outlined, 'Wardrobe'),
    (Icons.calendar_today_outlined, 'Calendar'),
    (Icons.person_outline, 'Profile'),
  ];


  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.paddingOf(context).bottom;
    Widget item(int i) {
      final active = i == index;
      final color = active ? AppColors.gold : AppColors.textTertiary;
      return Expanded(
        child: InkWell(
          onTap: () => onTap(i),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 2,
                color: active ? AppColors.gold : Colors.transparent,
              ),
              const SizedBox(height: 10),
              Icon(_items[i].$1, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                _items[i].$2,
                style: AppText.body(
                  11,
                  weight: active ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      );
    }


    return SizedBox(
      height: height + inset,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            top: height - 72,
            child: Container(
              padding: EdgeInsets.only(bottom: inset),
              decoration: const BoxDecoration(
                color: AppColors.bgSurface,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  item(0),
                  item(1),
                  const SizedBox(width: addSize + 16),
                  item(2),
                  item(3),
                ],
              ),
            ),
          ),
          AddButton(onPressed: onAdd),
        ],
      ),
    );
  }
}


/// Tombol + emas bulat.
class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.onPressed});


  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.gold,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.bgBase, width: 4),
      ),
      elevation: 6,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const SizedBox.square(
          dimension: AppBottomNav.addSize,
          child: Icon(Icons.add, color: AppColors.bgBase, size: 30),
        ),
      ),
    );
  }
}
