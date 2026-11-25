import 'auth_service.dart';
import 'mappers.dart';
import 'models.dart';
import 'supabase_config.dart';

/// Baca dan simpan profil user di tabel "profiles".
class ProfileRepository {
  ProfileRepository._();

  /// Null kalau user baru dan belum mengisi Basic Info.
  static Future<UserProfile?> fetch() async {
    final row = await supabase
        .from('profiles')
        .select()
        .eq('id', AuthService.userId)
        .maybeSingle();
    return row == null ? null : profileFromRow(row);
  }

  static Future<void> save(UserProfile u) =>
      supabase.from('profiles').upsert(profileToRow(AuthService.userId, u));
}
