import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:work_tracker/src/features/profile/services/profile_service.dart';

import 'src/app.dart';
import 'src/features/settings/services/dark_theme_provider.dart';
import 'src/features/Authentication/services/authentication_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  final DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeChangeProvider),
        Provider(create: (_) => AuthenticationServices()),
        StreamProvider<bool>(
          create: (context) => context.read<AuthenticationServices>().onAuthStateChanged,
          initialData: false,
        ),
        Provider(create: (_) => ProfileService()),
      ],
      child: const MyApp(),
    ),
  );
}
