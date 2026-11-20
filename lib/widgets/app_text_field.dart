import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Input teks dengan label di atas, border emas saat fokus,
/// dan tombol mata untuk password.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.obscure = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppText.body(13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _hidden,
          keyboardType: widget.keyboardType,
          cursorColor: AppColors.gold,
          style: AppText.body(15),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppText.body(15, color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.bgElevated,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            prefixIcon: widget.icon == null
                ? null
                : Icon(widget.icon, color: AppColors.textSecondary, size: 20),
            suffixIcon: widget.obscure
                ? IconButton(
                    onPressed: () => setState(() => _hidden = !_hidden),
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  )
                : null,
            enabledBorder: border(AppColors.borderSubtle),
            focusedBorder: border(AppColors.gold),
          ),
        ),
      ],
    );
  }
}
