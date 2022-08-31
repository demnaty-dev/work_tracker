import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/services/storage_services.dart';

import '../../../constants/palette.dart';
import '../../Authentication/services/authentication_services.dart';
import '../../profile/pages/profile.dart';
import '../services/dark_theme_provider.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: theme.textTheme.headline6,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 24),
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  onTap: () => Navigator.pushNamed(context, Profile.routeName),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.secondary,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Profile',
                            style: theme.textTheme.subtitle1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Consumer<DarkThemeProvider>(
                  builder: (_, v, __) {
                    return InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      onTap: () => v.darkTheme = !v.darkTheme,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.secondary,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dark Mode',
                                style: theme.textTheme.subtitle1,
                              ),
                              Switch(
                                onChanged: (b) => v.darkTheme = b,
                                value: v.darkTheme,
                                activeColor: theme.primaryColor,
                                activeTrackColor: theme.primaryColor.withAlpha(150),
                                inactiveThumbColor: textField,
                                inactiveTrackColor: textField.withAlpha(150),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                TextButton.icon(
                  onPressed: () async {
                    await context.read<StorageServices?>()!.deleteFiles().then(
                      (value) {
                        return context.read<AuthenticationServices>().signOut();
                      },
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
