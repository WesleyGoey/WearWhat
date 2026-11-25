import 'dart:typed_data';


import 'package:flutter/material.dart';


import 'models.dart';
import 'outfit_repository.dart';
import 'profile_repository.dart';
import 'uuid.dart';
import 'wardrobe_repository.dart';


/// Dipasang di MaterialApp supaya AppState bisa menampilkan snackbar error.
final appMessengerKey = GlobalKey<ScaffoldMessengerState>();


/// State global aplikasi. Data diambil dari Supabase saat login ([load]),
/// lalu setiap perubahan langsung tampil di layar dan disimpan ke Supabase
/// di belakang layar.
class AppState extends ChangeNotifier {
  AppState._();
  static final instance = AppState._();


  final List<ClothingItem> items = [];
  final List<Outfit> outfits = [];
  final Map<DateTime, List<String>> plans = {};
  UserProfile user = UserProfile();


  /// False untuk akun baru yang belum mengisi Basic Info.
  bool hasProfile = false;


  /// Tab aktif di bottom nav: 0 Home, 1 Wardrobe, 2 Calendar, 3 Profile.
  int tab = 0;


  /// Coach-mark "Tap + to add" muncul sekali setelah onboarding.
  bool showTutorial = false;


  String newId() => newUuid();


  /// Ambil semua data user yang sedang login dari Supabase.
  Future<void> load() async {
    final profile = await ProfileRepository.fetch();
    final results = await Future.wait([
      WardrobeRepository.fetchAll(),
      OutfitRepository.fetchOutfits(),
      OutfitRepository.fetchPlans(),
    ]);
    items
      ..clear()
      ..addAll(results[0] as List<ClothingItem>);
    outfits
      ..clear()
      ..addAll(results[1] as List<Outfit>);
    plans
      ..clear()
      ..addAll(results[2] as Map<DateTime, List<String>>);
    hasProfile = profile != null && profile.name.isNotEmpty;
    user = profile ?? UserProfile();
    notifyListeners();
  }


  /// Simpan ke Supabase tanpa membuat layar menunggu. Kalau gagal,
  /// tampilkan snackbar supaya user tahu datanya belum tersimpan.
  void _sync(Future<void> Function() save) {
    // Future.sync juga menangkap error yang terjadi sebelum Future dibuat.
    Future.sync(save).catchError((Object e) {
      debugPrint('Supabase save failed: $e');
      appMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Could not save to the server. Check your connection.'),
        ),
      );
    });
  }


  ClothingItem item(String id) => items.firstWhere((i) => i.id == id);
  Outfit? outfitOrNull(String id) =>
      outfits.where((o) => o.id == id).firstOrNull;


  /// Item sebuah outfit, urut sesuai ClothingCategory.
  List<ClothingItem> itemsOf(Outfit o) => [
    for (final c in ClothingCategory.values)
      if (o.items[c] != null && items.any((i) => i.id == o.items[c]))
        item(o.items[c]!),
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


  /// Menunggu upload foto dan insert selesai, supaya layar Review bisa
  /// menampilkan loading dan error.
  Future<void> addItem(ClothingItem i, {Uint8List? photo}) async {
    await WardrobeRepository.add(i, photo: photo);
    items.insert(0, i);
    notifyListeners();
  }


  void setCooldown(ClothingItem i, bool value) {
    i.cooldown = value;
    notifyListeners();
    _sync(() => WardrobeRepository.saveAll([i]));
  }


  void saveOutfit(Outfit o) {
    if (!outfits.contains(o)) outfits.add(o);
    notifyListeners();
    _sync(() => OutfitRepository.save(o));
  }


  void deleteOutfit(String id) {
    outfits.removeWhere((o) => o.id == id);
    for (final list in plans.values) {
      list.remove(id);
    }
    notifyListeners();
    _sync(() => OutfitRepository.delete(id));
  }


  void plan(DateTime d, String outfitId) {
    final list = plans.putIfAbsent(dateOnly(d), () => []);
    if (list.contains(outfitId)) return;
    list.add(outfitId);
    notifyListeners();
    _sync(() => OutfitRepository.plan(d, outfitId));
  }


  void unplan(DateTime d, String outfitId) {
    plans[dateOnly(d)]?.remove(outfitId);
    notifyListeners();
    _sync(() => OutfitRepository.unplan(d, outfitId));
  }


  // Nilai sebelum Mark as Worn, untuk tombol Undo di snackbar.
  final _wornBackup =
      <String, (DateTime?, List<(ClothingItem, int, DateTime?, bool)>)>{};


  bool isWornToday(Outfit o) =>
      o.lastWornOn != null && o.lastWornOn == dateOnly(DateTime.now());


  /// Tambah worn counter dan otomatis set Cooldown.
  void markWorn(Outfit o) {
    if (isWornToday(o)) return;
    final worn = itemsOf(o);
    _wornBackup[o.id] = (
      o.lastWornOn,
      [for (final i in worn) (i, i.worn, i.lastWorn, i.cooldown)],
    );
    o.lastWornOn = dateOnly(DateTime.now());
    for (final i in worn) {
      i.worn++;
      i.lastWorn = DateTime.now();
      i.cooldown = true;
    }
    notifyListeners();
    _sync(() async {
      await WardrobeRepository.saveAll(worn);
      await OutfitRepository.save(o);
    });
  }


  /// Batalkan Mark as Worn (tombol Undo di snackbar).
  void undoWorn(Outfit o) {
    final backup = _wornBackup.remove(o.id);
    if (backup == null) return;
    final (lastWornOn, values) = backup;
    o.lastWornOn = lastWornOn;
    for (final (i, worn, lastWorn, cooldown) in values) {
      i.worn = worn;
      i.lastWorn = lastWorn;
      i.cooldown = cooldown;
    }
    notifyListeners();
    _sync(() async {
      await WardrobeRepository.saveAll([for (final v in values) v.$1]);
      await OutfitRepository.save(o);
    });
  }


  void updateUser(UserProfile u) {
    user = u;
    hasProfile = u.name.isNotEmpty;
    notifyListeners();
    _sync(() => ProfileRepository.save(u));
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


  /// Kosongkan data di HP saat logout, supaya akun berikutnya tidak melihatnya.
  void logout() {
    items.clear();
    outfits.clear();
    plans.clear();
    user = UserProfile();
    hasProfile = false;
    _wornBackup.clear();
    tab = 0;
    showTutorial = false;
    notifyListeners();
  }
}
