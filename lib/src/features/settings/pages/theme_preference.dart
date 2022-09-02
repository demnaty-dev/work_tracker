import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/palette.dart';
import '../services/theme_provider.dart';

enum ThemeState { light, dark, system }

class ThemePreference extends StatefulWidget {
  static const routeName = '/theme-preference';

  const ThemePreference({Key? key}) : super(key: key);

  @override
  State<ThemePreference> createState() => _ThemePreferenceState();
}

class _ThemePreferenceState extends State<ThemePreference> {
  late ThemeState _themeState;

  @override
  void initState() {
    super.initState();
    final index = context.read<ThemeProvider>().themeState;
    _themeState = ThemeState.values[index];
  }

  void _onChanged(ThemeState? val) {
    context.read<ThemeProvider>().themeState = val!.index;
    setState(() => _themeState = val);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = context.read<ThemeProvider>().isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 63,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.chevron_left,
                          color: isDark ? textColorDarkTheme : textColorLightTheme,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Theme',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline6,
                    ),
                  ),
                  const Expanded(
                    child: Text(''),
                  ),
                ],
              ),
            ),
            RadioListTile<ThemeState>(
              title: const Text('Light'),
              value: ThemeState.light,
              groupValue: _themeState,
              onChanged: _onChanged,
            ),
            RadioListTile<ThemeState>(
              title: const Text('Dark'),
              value: ThemeState.dark,
              groupValue: _themeState,
              onChanged: _onChanged,
            ),
            RadioListTile<ThemeState>(
              title: const Text('System'),
              value: ThemeState.system,
              groupValue: _themeState,
              onChanged: _onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
