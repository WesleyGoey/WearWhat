import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';

/// Sheet dari tombol +: pilih tambah pakaian atau buat outfit.
Future<void> showAddSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      void go(String route) {
        Navigator.pop(sheetContext);
        Navigator.pushNamed(context, route);
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'What do you want to add?',
                      style: AppText.display(22),
                    ),
                  ),
                  CircleIconButton(
                    icon: Icons.close,
                    size: 34,
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _Option(
                icon: Icons.checkroom,
                title: 'Add a clothing item',
                subtitle: 'Photo of one piece, AI sorts it',
                onTap: () => go(Routes.addClothesPhoto),
              ),
              const SizedBox(height: 10),
              _Option(
                icon: Icons.auto_awesome,
                title: 'Create an outfit',
                subtitle: 'Mix your own items, or let AI style you',
                onTap: () => go(Routes.addOutfit),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.goldTint,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldDark),
                ),
                child: Icon(icon, color: AppColors.gold, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.body(15, weight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppText.body(12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
