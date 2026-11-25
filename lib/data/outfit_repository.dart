import 'mappers.dart';
import 'models.dart';
import 'supabase_config.dart';

/// Outfit di tabel "outfits" dan jadwal kalender di tabel "plans".
class OutfitRepository {
  OutfitRepository._();

  static Future<List<Outfit>> fetchOutfits() async {
    final rows = await supabase
        .from('outfits')
        .select()
        .order('created_at', ascending: true);
    return [for (final r in rows) outfitFromRow(r)];
  }

  /// Tanggal -> daftar id outfit di tanggal itu.
  static Future<Map<DateTime, List<String>>> fetchPlans() async {
    final rows = await supabase
        .from('plans')
        .select('date, outfit_id')
        .order('created_at', ascending: true);
    final plans = <DateTime, List<String>>{};
    for (final r in rows) {
      plans
          .putIfAbsent(parseDate(r['date'] as String), () => [])
          .add(r['outfit_id'] as String);
    }
    return plans;
  }

  /// Insert outfit baru atau update outfit yang sudah ada (id sama).
  static Future<void> save(Outfit o) =>
      supabase.from('outfits').upsert(outfitToRow(o));

  /// Rencana di kalender ikut terhapus (on delete cascade di schema.sql).
  static Future<void> delete(String outfitId) =>
      supabase.from('outfits').delete().eq('id', outfitId);

  static Future<void> plan(DateTime d, String outfitId) =>
      supabase.from('plans').upsert({
        'date': toDateString(d),
        'outfit_id': outfitId,
      }, ignoreDuplicates: true);

  static Future<void> unplan(DateTime d, String outfitId) => supabase
      .from('plans')
      .delete()
      .eq('date', toDateString(d))
      .eq('outfit_id', outfitId);
}
