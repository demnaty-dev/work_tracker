import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/projects/pages/complaint.dart';

import 'features/Authentication/pages/forgot_password.dart';
import 'features/Authentication/pages/log_in.dart';
import 'features/inbox/pages/inbox_detail.dart';
import 'features/pdf_viewer/pages/pdf_viewer.dart';
import 'features/profile/pages/edit_profile.dart';
import 'features/profile/pages/profile.dart';
import 'features/projects/pages/project_detail.dart';
import 'features/projects/pages/projects_list.dart';
import 'features/settings/pages/theme_preference.dart';
import 'features/settings/services/theme_provider.dart';
import 'features/room/pages/room.dart';

import 'pages/loading_page.dart';
import 'pages/home.dart';

import 'constants/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeProvider>().themeState;
    ThemeMode theme;
    if (themeState == ThemeProvider.systemTheme) {
      theme = ThemeMode.system;
    } else if (themeState == ThemeProvider.darkTheme) {
      theme = ThemeMode.dark;
    } else {
      theme = ThemeMode.light;
    }

    return MaterialApp(
      title: 'Work Tracker',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: theme,
      home: Consumer<bool>(
        builder: (_, userExist, __) {
          if (userExist) {
            return const LoadingPage();
          }
          return const LogIn();
        },
      ),
      routes: {
        Home.routeName: (_) {
          return Consumer<bool>(
            builder: (_, userExist, __) {
              if (userExist) {
                return const Home();
              }
              return const LogIn();
            },
          );
        },
        ThemePreference.routeName: (_) => const ThemePreference(),
        ForgotPassword.routeName: (_) => const ForgotPassword(),
        Profile.routeName: (_) => const Profile(),
        EditProfile.routeName: (_) => const EditProfile(),
        InboxDetail.routeName: (_) => const InboxDetail(),
        PDFViewer.routeName: (_) => const PDFViewer(),
        ProjectsList.routeName: (_) => const ProjectsList(),
        Room.routeName: (_) => const Room(),
        ProjectDetail.routeName: (_) => const ProjectDetail(),
        Complaint.routeName: (_) => const Complaint(),
      },
    );
  }
}
