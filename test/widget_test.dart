import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wearwhat/app/routes.dart';
import 'package:wearwhat/data/app_state.dart';
import 'package:wearwhat/data/mappers.dart';
import 'package:wearwhat/data/models.dart';
import 'package:wearwhat/data/uuid.dart';
import 'package:wearwhat/main.dart';


void main() {
  // Test tidak boleh download font dari internet.
  GoogleFonts.config.allowRuntimeFetching = false;


  testWidgets('Welcome screen tampil dengan tombol Sign Up dan Log In', (
    tester,
  ) async {
    await tester.pumpWidget(const WearWhatApp());
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });


  testWidgets('Log In dengan email salah menampilkan pesan error', (
    tester,
  ) async {
    await tester.pumpWidget(const WearWhatApp());
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'bukan-email');
    await tester.tap(find.widgetWithText(FilledButton, 'Log In'));
    await tester.pump();
    expect(find.text('Enter a valid email and password.'), findsOneWidget);
  });


  testWidgets('Akun baru tanpa data: semua tab tampil tanpa error', (
    tester,
  ) async {
    // Ukuran layar HP (412 x 917), sama dengan frame Figma.
    tester.view.physicalSize = const Size(1236, 2751);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    AppState.instance.logout();
    await tester.pumpWidget(const WearWhatApp(initialRoute: Routes.main));
    await tester.pumpAndSettle();
    expect(find.text("Today's Outfit"), findsOneWidget);
    for (final tab in ['Wardrobe', 'Calendar', 'Profile', 'Home']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });


  test('newUuid menghasilkan UUID versi 4 yang unik', () {
    final id = newUuid();
    expect(
      RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      ).hasMatch(id),
      isTrue,
    );
    expect(newUuid(), isNot(id));
  });


  test(
    'Baju, outfit, dan profil tetap sama setelah diubah ke baris Supabase',
    () {
      final item = ClothingItem(
        id: newUuid(),
        category: ClothingCategory.bottom,
        color: const Color(0xFF243656),
        seasons: {Season.summer, Season.rainy},
        worn: 3,
        lastWorn: DateTime(2026, 11, 20, 8, 30),
        cooldown: true,
        photoPath: 'user/abc.jpg',
      );
      final itemBack = itemFromRow(itemToRow(item));
      expect(itemBack.category, item.category);
      expect(itemBack.color, item.color);
      expect(itemBack.seasons, item.seasons);
      expect(itemBack.worn, 3);
      expect(itemBack.lastWorn, item.lastWorn);
      expect(itemBack.cooldown, isTrue);
      expect(itemBack.photoPath, 'user/abc.jpg');


      final outfit = Outfit(
        id: newUuid(),
        name: 'Outfit 1',
        items: {ClothingCategory.top: 'a', ClothingCategory.shoes: 'b'},
        lastWornOn: DateTime(2026, 11, 24),
      );
      final outfitBack = outfitFromRow(outfitToRow(outfit));
      expect(outfitBack.name, 'Outfit 1');
      expect(outfitBack.items, outfit.items);
      expect(outfitBack.lastWornOn, DateTime(2026, 11, 24));


      final user = UserProfile(
        name: 'Alex',
        age: 21,
        gender: Gender.female,
        skinTone: 4,
      );
      final userBack = profileFromRow(profileToRow('user-id', user));
      expect(userBack.name, 'Alex');
      expect(userBack.age, 21);
      expect(userBack.gender, Gender.female);
      expect(userBack.skinTone, 4);
    },
  );


  test('Mark as Worn menambah worn dan Undo mengembalikannya', () {
    final state = AppState.instance..logout();
    final top = ClothingItem(
      id: 't',
      category: ClothingCategory.top,
      color: const Color(0xFFFFFFFF),
      worn: 2,
    );
    final outfit = Outfit(
      id: 'o',
      name: 'Outfit 1',
      items: {ClothingCategory.top: 't'},
    );
    state.items.add(top);
    state.outfits.add(outfit);


    state.markWorn(outfit);
    expect(top.worn, 3);
    expect(top.cooldown, isTrue);
    expect(state.isWornToday(outfit), isTrue);


    state.undoWorn(outfit);
    expect(top.worn, 2);
    expect(top.cooldown, isFalse);
    expect(state.isWornToday(outfit), isFalse);
    state.logout();
  });
}
