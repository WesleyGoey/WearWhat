import 'package:flutter/foundation.dart';

import 'dummy_data.dart';
import 'models.dart';

/// State global aplikasi, disimpan di memori.
/// shortcut: data hilang saat app ditutup; ganti ke backend/database saat S2-03 diputuskan.
class AppState extends ChangeNotifier {
  AppState._();
  static final instance = AppState._();

  final List<ClothingItem> items = dummyItems();
  final List<Outfit> outfits = dummyOutfits();
  final Map<DateTime, List<String>> plans = dummyPlans();
  UserProfile user = dummyUser();

  /// Tab aktif di bottom nav: 0 Home, 1 Wardrobe, 2 Calendar, 3 Profile.
  int tab = 0;

  /// Coach-mark "Tap + to add" muncul sekali setelah onboarding.
  bool showTutorial = false;

  int _nextId = 100;
  String newId() => 'id${_nextId++}';

  ClothingItem item(String id) => items.firstWhere((i) => i.id == id);
  Outfit? outfitOrNull(String id) =>
      outfits.where((o) => o.id == id).firstOrNull;

  /// Item sebuah outfit, urut sesuai ClothingCategory.
  List<ClothingItem> itemsOf(Outfit o) => [
    for (final c in ClothingCategory.values)
      if (o.items[c] != null) item(o.items[c]!),
  ];

  List<Outfit> outfitsOn(DateTime d) => [
    for (final id in plans[dateOnly(d)] ?? const <String>[])
      if (outfitOrNull(id) != null) outfitOrNull(id)!,
  ];

  List<Outfit> outfitsUsing(ClothingItem it) =>
      outfits.where((o) => o.items.containsValue(it.id)).toList();

  /// Tanggal terdekat (mulai hari ini) outfit dijadwalkan, atau null.
  DateTime? nextPlanOf(Outfit o) {
    final today = dateOnly(DateTime.now());
    final dates =
        plans.entries
            .where((e) => !e.key.isBefore(today) && e.value.contains(o.id))
            .map((e) => e.key)
            .toList()
          ..sort();
    return dates.firstOrNull;
  }

  void setTab(int i) {
    tab = i;
    notifyListeners();
  }

  void addItem(ClothingItem i) {
    items.insert(0, i);
    notifyListeners();
  }

  void setCooldown(ClothingItem i, bool value) {
    i.cooldown = value;
    notifyListeners();
  }

  void saveOutfit(Outfit o) {
    if (!outfits.contains(o)) outfits.add(o);
    notifyListeners();
  }

  void deleteOutfit(String id) {
    outfits.removeWhere((o) => o.id == id);
    for (final list in plans.values) {
      list.remove(id);
    }
    notifyListeners();
  }

  void plan(DateTime d, String outfitId) {
    plans.putIfAbsent(dateOnly(d), () => []).add(outfitId);
    notifyListeners();
  }

  void unplan(DateTime d, String outfitId) {
    plans[dateOnly(d)]?.remove(outfitId);
    notifyListeners();
  }

  // Nilai item sebelum Mark as Worn, per outfit, untuk tombol Undo.
  // shortcut: hanya di memori dan tidak reset saat ganti hari, ganti saat ada backend.
  final _wornBackup = <String, List<(ClothingItem, int, DateTime?, bool)>>{};

  bool isWornToday(Outfit o) => _wornBackup.containsKey(o.id);

  /// Tambah worn counter dan otomatis set Cooldown.
  void markWorn(Outfit o) {
    if (isWornToday(o)) return;
    final items = itemsOf(o);
    _wornBackup[o.id] = [
      for (final i in items) (i, i.worn, i.lastWorn, i.cooldown),
    ];
    for (final i in items) {
      i.worn++;
      i.lastWorn = DateTime.now();
      i.cooldown = true;
    }
    notifyListeners();
  }

  /// Batalkan Mark as Worn (tombol Undo di snackbar).
  void undoWorn(Outfit o) {
    final backup = _wornBackup.remove(o.id);
    if (backup == null) return;
    for (final (i, worn, lastWorn, cooldown) in backup) {
      i.worn = worn;
      i.lastWorn = lastWorn;
      i.cooldown = cooldown;
    }
    notifyListeners();
  }

  void updateUser(UserProfile u) {
    user = u;
    notifyListeners();
  }

  void finishOnboarding() {
    tab = 0;
    showTutorial = true;
    notifyListeners();
  }

  void dismissTutorial() {
    showTutorial = false;
    notifyListeners();
  }

  void logout() {
    tab = 0;
    showTutorial = false;
    notifyListeners();
  }
}
