import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'src/features/Authentication/services/authentication_services.dart';
import 'src/features/settings/services/dark_theme_provider.dart';
import 'src/features/profile/services/profile_service.dart';
import 'src/features/inbox/services/inbox_services.dart';
import 'src/services/storage_services.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        ProxyProvider<bool, InboxServices?>(
          update: (context, value, __) {
            final user = context.read<AuthenticationServices>().currentUser();
            if (user == null) return null;
            return InboxServices(user);
          },
        ),
        ProxyProvider<bool, StorageServices?>(
          update: (context, value, _) {
            if (value) {
              return StorageServices();
            }
            return null;
          },
        ),
        ProxyProvider<StorageServices?, ProfileService?>(
          update: (context, value, __) {
            if (value == null) return null;
            final user = context.read<AuthenticationServices>().currentUser()!;

            return ProfileService(user, context.read<StorageServices?>()!);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
