import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

/// Login, daftar, dan logout lewat Supabase Auth (email dan password).
class AuthService {
  AuthService._();

  static bool get isLoggedIn =>
      SupabaseConfig.isConfigured && supabase.auth.currentSession != null;

  static String get userId => supabase.auth.currentUser!.id;

  /// Mengembalikan pesan error untuk ditampilkan, atau null kalau berhasil.
  static Future<String?> signIn(String email, String password) => _run(
    () => supabase.auth.signInWithPassword(email: email, password: password),
  );

  /// Mengembalikan pesan error, atau null kalau berhasil dan sudah login.
  /// Kalau project Supabase mewajibkan konfirmasi email, user belum login
  /// setelah daftar, jadi kita minta dia cek email dulu.
  static Future<String?> signUp(String email, String password) async {
    final error = await _run(
      () => supabase.auth.signUp(email: email, password: password),
    );
    if (error != null) return error;
    if (supabase.auth.currentSession == null) {
      return 'Check your email to confirm your account, then log in.';
    }
    return null;
  }

  static Future<void> signOut() async {
    if (SupabaseConfig.isConfigured) await supabase.auth.signOut();
  }

  static Future<String?> _run(Future<AuthResponse> Function() call) async {
    if (!SupabaseConfig.isConfigured) {
      return 'Supabase is not set up. Run the app with env.json.';
    }
    try {
      await call();
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not reach the server. Check your connection.';
    }
  }
}
