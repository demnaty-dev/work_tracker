import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/Authentication/models/user_model.dart';
import 'features/Authentication/pages/log_in.dart';
import 'features/settings/services/dark_theme_provider.dart';
import 'pages/home.dart';

import 'constants/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: context.watch<DarkThemeProvider>().darkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Consumer<UserModel?>(
        builder: (_, user, __) {
          if (user != null) {
            return const Home();
          }
          return const LogIn();
        },
      ),
    );
  }
}
