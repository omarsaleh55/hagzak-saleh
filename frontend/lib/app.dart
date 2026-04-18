import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class KoraaApp extends StatelessWidget {
  const KoraaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login, // TODO: change back to AppRoutes.home
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
