import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/clothing_art.dart';
import '../../widgets/profile_pickers.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => const _LogoutDialog(),
    );
    if (ok != true || !context.mounted) return;
    AppState.instance.logout();
    Navigator.pushNamedAndRemoveUntil(context, Routes.welcome, (_) => false);
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final u = state.user;
        final mostWorn = [...state.items]
          ..sort((a, b) => b.worn.compareTo(a.worn));
        final top3 = mostWorn.take(3).toList();
        final maxWorn = top3.isEmpty || top3.first.worn == 0
            ? 1
            : top3.first.worn;


        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Text('Profile', style: AppText.display(32)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.goldDark),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.goldTint, AppColors.bgSurface],
                  ),
                ),
                child: Column(
                  children: [
                    SelfieAvatar(tone: u.skinTone, size: 76),
                    const SizedBox(height: 10),
                    Text(u.name, style: AppText.display(24)),
                    Text(
                      '${u.age} · ${u.gender.label}',
                      style: AppText.body(12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 6,
                          backgroundColor: skinTones[u.skinTone].color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Skin tone · ${skinTones[u.skinTone].name}',
                          style: AppText.body(
                            12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    OutlineGoldButton(
                      label: 'Edit Profile',
                      icon: Icons.edit_outlined,
                      height: 40,
                      expand: false,
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.editProfile),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _Stat(value: state.items.length, label: 'Clothes'),
                  const SizedBox(width: 10),
                  _Stat(value: state.outfits.length, label: 'Outfits'),
                  const SizedBox(width: 10),
                  _Stat(
                    value: state.items.where((i) => i.cooldown).length,
                    label: 'In cooldown',
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'Most worn clothes',
                style: AppText.body(16, weight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < top3.length; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        child: Text(
                          '${i + 1}',
                          style: AppText.display(18, color: AppColors.gold),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClothingArt(
                          category: top3[i].category,
                          color: top3[i].color,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              top3[i].category.label,
                              style: AppText.body(13, weight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: top3[i].worn / maxWorn,
                                minHeight: 5,
                                backgroundColor: AppColors.borderSubtle,
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${top3[i].worn}×', style: AppText.body(13)),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              SecondaryButton(
                label: 'Log Out',
                icon: Icons.logout,
                color: AppColors.danger,
                onPressed: () => _logout(context),
              ),
            ],
          ),
        );
      },
    );
  }
}


class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});


  final int value;
  final String label;


  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: AppText.display(24, color: AppColors.goldLight),
          ),
          Text(label, style: AppText.body(11, color: AppColors.textSecondary)),
        ],
      ),
    ),
  );
}


class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.danger,
              child: Icon(Icons.logout, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 14),
            Text('Log out?', style: AppText.display(24)),
            const SizedBox(height: 6),
            Text(
              "You'll be taken back to the welcome screen.",
              textAlign: TextAlign.center,
              style: AppText.body(13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Cancel',
                    height: 46,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: AppColors.textPrimary,
                      minimumSize: const Size.fromHeight(46),
                    ),
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
