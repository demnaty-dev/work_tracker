import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/app.dart';
import 'package:work_tracker/src/features/settings/dark_theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeChangeProvider),
      ],
      child: const MyApp(),
    ),
  );
}
