import 'package:flutter/material.dart';


import 'app/app_router.dart';
import 'app/routes.dart';
import 'app/session.dart';
import 'data/app_state.dart';
import 'data/auth_service.dart';
import 'data/supabase_config.dart';
import 'theme/app_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();


  // Kalau masih ada sesi login dari sebelumnya, langsung muat data user.
  var initialRoute = Routes.welcome;
  if (AuthService.isLoggedIn) {
    try {
      initialRoute = await startSession();
    } catch (e) {
      debugPrint('Could not load user data: $e');
    }
  }
  runApp(WearWhatApp(initialRoute: initialRoute));
}


class WearWhatApp extends StatelessWidget {
  const WearWhatApp({super.key, this.initialRoute = Routes.welcome});


  final String initialRoute;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WearWhat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      scaffoldMessengerKey: appMessengerKey,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
