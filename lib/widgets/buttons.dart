import 'package:flutter/material.dart';


import '../theme/app_colors.dart';


/// Tombol emas utama (Sign Up, Next, Save, dst).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });


  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.bgBase,
          disabledBackgroundColor: AppColors.goldDark,
          shape: const StadiumBorder(),
        ),
        child: _Label(label: label, icon: icon, weight: FontWeight.w600),
      ),
    );
  }
}


/// Tombol garis emas (Log In di Welcome, Edit, Cancel).
class OutlineGoldButton extends StatelessWidget {
  const OutlineGoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 54,
    this.expand = true,
  });


  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final bool expand;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: _Label(label: label, icon: icon, weight: FontWeight.w500),
      ),
    );
  }
}


/// Tombol gelap (Continue with Google, Log Out, Remove from day).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
    this.color = AppColors.textPrimary,
    this.height = 54,
  });


  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? leading;
  final Color color;
  final double height;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.bgElevated,
          foregroundColor: color,
          shape: const StadiumBorder(
            side: BorderSide(color: AppColors.borderSubtle),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 10)],
            Flexible(
              child: _Label(label: label, icon: icon, weight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}


/// Tombol bulat gelap untuk ikon (Back, Search, Notifikasi).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 40,
    this.tooltip,
  });


  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final String? tooltip;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgElevated,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.borderSubtle),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox.square(
          dimension: size,
          child: Tooltip(
            message: tooltip ?? '',
            child: Icon(icon, size: size * .5, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}


class _Label extends StatelessWidget {
  const _Label({required this.label, this.icon, required this.weight});


  final String label;
  final IconData? icon;
  final FontWeight weight;


  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 15, fontWeight: weight),
    );
    if (icon == null) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Flexible(child: text),
      ],
    );
  }
}
