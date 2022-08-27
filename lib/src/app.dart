import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/Authentication/pages/forgot_password.dart';
import 'features/inbox/pages/inbox_detail.dart';
import 'features/pdf_viewer/pages/pdf_viewer.dart';
import 'features/profile/pages/edit_profile.dart';
import 'features/profile/pages/profile.dart';

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
      title: 'Work Tracker',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: context.watch<DarkThemeProvider>().darkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Consumer<bool>(
        builder: (_, userExist, __) {
          if (userExist) {
            return const Home();
          }
          return const LogIn();
        },
      ),
      routes: {
        ForgotPassword.routeName: (_) => const ForgotPassword(),
        Profile.routeName: (_) => const Profile(),
        EditProfile.routeName: (_) => const EditProfile(),
        InboxDetail.routeName: (_) => const InboxDetail(),
        PDFViewer.routeName: (_) => const PDFViewer(),
      },
    );
  }
}
