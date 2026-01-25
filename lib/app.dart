import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';
import 'providers/theme_provider.dart';
import 'features/favorites/favorites_screen.dart';
import 'features/profile/recently_viewed_screen.dart';
import 'config/routes.dart';

class AutomobileApp extends StatelessWidget {
  const AutomobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AutoMobile',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          routes: {
            ...AppRoutes.routes,
            '/saved-vehicles': (context) => const FavoritesScreen(),
            '/recently-viewed': (context) => const RecentlyViewedScreen(),
          },
        );
      },
    );
  }
}
