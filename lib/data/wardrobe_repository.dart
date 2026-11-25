import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';
import 'mappers.dart';
import 'models.dart';
import 'supabase_config.dart';

/// Baju di tabel "clothing_items" dan fotonya di bucket Storage "clothes".
class WardrobeRepository {
  WardrobeRepository._();

  // shortcut: link foto berlaku 7 hari; kalau app dibuka lebih lama dari itu,
  // foto baru muncul lagi setelah app dibuka ulang.
  static const _urlSeconds = 60 * 60 * 24 * 7;

  static StorageFileApi get _bucket =>
      supabase.storage.from(SupabaseConfig.clothesBucket);

  /// Semua baju milik user, terbaru di atas, lengkap dengan link fotonya.
  static Future<List<ClothingItem>> fetchAll() async {
    final rows = await supabase
        .from('clothing_items')
        .select()
        .order('created_at', ascending: false);
    final items = [for (final r in rows) itemFromRow(r)];
    final paths = [
      for (final i in items)
        if (i.photoPath != null) i.photoPath!,
    ];
    if (paths.isNotEmpty) {
      final urls = await _bucket.createSignedUrlsResult(paths, _urlSeconds);
      final byPath = {
        for (final u in urls)
          if (u is SignedUrlSuccess) u.path: u.signedUrl,
      };
      for (final i in items) {
        i.photoUrl = byPath[i.photoPath];
      }
    }
    return items;
  }

  /// Upload foto dulu (kalau ada), lalu simpan barisnya.
  static Future<void> add(ClothingItem item, {Uint8List? photo}) async {
    if (photo != null) {
      final path = '${AuthService.userId}/${item.id}.jpg';
      await _bucket.uploadBinary(
        path,
        photo,
        fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
      );
      item.photoPath = path;
      item.photoUrl = await _bucket.createSignedUrl(path, _urlSeconds);
    }
    await supabase.from('clothing_items').insert(itemToRow(item));
  }

  /// Simpan perubahan worn, cooldown, dan lainnya untuk beberapa baju sekaligus.
  static Future<void> saveAll(List<ClothingItem> items) => supabase
      .from('clothing_items')
      .upsert([for (final i in items) itemToRow(i)]);
}
