import 'package:flutter/material.dart';

import '../screens/add/add_clothes_photo_screen.dart';
import '../screens/add/add_clothes_review_screen.dart';
import '../screens/add/add_outfit_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/main_shell.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/setup/basic_info_screen.dart';
import '../screens/setup/selfie_intro_screen.dart';
import '../screens/setup/selfie_screen.dart';
import '../screens/setup/skin_tone_screen.dart';
import '../screens/wardrobe/item_detail_screen.dart';
import '../screens/wardrobe/outfit_detail_screen.dart';
import 'routes.dart';

/// Menghubungkan nama route ke layar. Dipakai MaterialApp.onGenerateRoute.
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final Widget page = switch (settings.name) {
    Routes.login => const LoginScreen(),
    Routes.signup => const SignupScreen(),
    Routes.basicInfo => const BasicInfoScreen(),
    Routes.selfieIntro => const SelfieIntroScreen(),
    Routes.selfie => const SelfieScreen(),
    Routes.skinTone => const SkinToneScreen(),
    Routes.main => const MainShell(),
    Routes.addClothesPhoto => const AddClothesPhotoScreen(),
    Routes.addClothesReview => const AddClothesReviewScreen(),
    Routes.addOutfit => const AddOutfitScreen(),
    Routes.itemDetail => const ItemDetailScreen(),
    Routes.outfitDetail => const OutfitDetailScreen(),
    Routes.editProfile => const EditProfileScreen(),
    _ => const WelcomeScreen(),
  };
  return MaterialPageRoute(builder: (_) => page, settings: settings);
}
