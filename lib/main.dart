import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/Authentication/models/user_model.dart';

import 'src/app.dart';
import 'src/features/settings/services/dark_theme_provider.dart';
import 'src/features/Authentication/services/authentication_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeChangeProvider),
        Provider(create: (_) => AuthenticationServices()),
        StreamProvider<UserModel?>(
          create: (context) => context.read<AuthenticationServices>().onAuthStateChanged,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}
