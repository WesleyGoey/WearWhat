import 'package:flutter/material.dart';

import 'app/app_router.dart';
import 'app/routes.dart';
import 'theme/app_theme.dart';

void main() => runApp(const WearWhatApp());

class WearWhatApp extends StatelessWidget {
  const WearWhatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WearWhat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: Routes.welcome,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
