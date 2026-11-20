import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headers.dart';
import '../../widgets/profile_pickers.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});


  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}


class _EditProfileScreenState extends State<EditProfileScreen> {
  final _user = AppState.instance.user;
  late final _name = TextEditingController(text: _user.name);
  late final _age = TextEditingController(text: '${_user.age}');
  late Gender _gender = _user.gender;
  late int _tone = _user.skinTone;


  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    super.dispose();
  }


  void _save() {
    final age = int.tryParse(_age.text);
    if (_name.text.trim().isEmpty || age == null || age < 1 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill in your name and a valid age.')),
      );
      return;
    }
    AppState.instance.updateUser(
      UserProfile(
        name: _name.text.trim(),
        age: age,
        gender: _gender,
        skinTone: _tone,
      ),
    );
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Edit Profile'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        SelfieAvatar(tone: _tone, size: 84),
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: AppColors.gold,
                            child: Icon(
                              Icons.photo_camera,
                              size: 14,
                              color: AppColors.bgBase,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        Routes.selfie,
                        arguments: {'retake': true},
                      ),
                      child: Text(
                        'Retake selfie',
                        style: AppText.body(
                          12,
                          weight: FontWeight.w600,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppTextField(label: 'Name', controller: _name),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Age',
                    controller: _age,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Gender',
                    style: AppText.body(13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  GenderSelector(
                    value: _gender,
                    onChanged: (g) => setState(() => _gender = g),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Skin tone',
                    style: AppText.body(13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  SkinTonePicker(
                    selected: _tone,
                    compact: true,
                    onChanged: (i) => setState(() => _tone = i),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlineGoldButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Save Changes',
                      onPressed: _save,
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
