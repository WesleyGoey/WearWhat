import 'package:supabase_flutter/supabase_flutter.dart';


/// URL dan kunci Supabase dibaca dari env.json saat run:
/// flutter run --dart-define-from-file=env.json
class SupabaseConfig {
  SupabaseConfig._();


  static const url = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );


  /// False kalau app dijalankan tanpa env.json (misalnya saat flutter test).
  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;


  /// Nama bucket Storage untuk foto baju (lihat supabase/schema.sql).
  static const clothesBucket = 'clothes';


  static Future<void> init() async {
    if (!isConfigured) return;
    await Supabase.initialize(url: url, publishableKey: publishableKey);
  }
}


/// Client Supabase yang dipakai semua repository.
SupabaseClient get supabase => Supabase.instance.client;
