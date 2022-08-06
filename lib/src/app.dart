import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/settings/dark_theme_provider.dart';

import 'constants/palette.dart';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 100),
            Text(
              'headline 4',
              style: textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Text(
              'headline 5',
              style: textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Text(
              'headline 6',
              style: textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            Text(
              'subtitle 1',
              style: textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            Text(
              'subtitle 2',
              style: textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
            Text(
              'bodyText 1',
              style: textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            Text(
              'bodyText 2',
              style: textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeChange.darkTheme ? textColorDarkTheme : bgColorDarkTheme,
        onPressed: () {
          themeChange.darkTheme = !(themeChange.darkTheme);
        },
        child: Icon(
          themeChange.darkTheme ? Icons.light_mode : Icons.dark_mode,
          color: themeChange.darkTheme ? bgColorDarkTheme : textColorDarkTheme,
        ),
      ),
    );
  }
}
