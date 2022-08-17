import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/palette.dart';
import '../../Authentication/models/user_model.dart';
import '../../profile/pages/edit_profile.dart';
import '../../settings/services/dark_theme_provider.dart';
import '../services/profile_service.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile';

  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userModel = context.read<ProfileService?>()!.userFromFirebase();

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 63,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.chevron_left,
                      color: context.read<DarkThemeProvider>().darkTheme ? textColorDarkTheme : textColorLightTheme,
                    ),
                  ),
                  Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline6,
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, EditProfile.routeName),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<UserModel?>(
                  future: userModel,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data == null) {
                      return const Center(
                        child: Text('empty'),
                      );
                    }
                    ImageProvider image;

                    if (snapshot.data!.photoUrl.startsWith('assets')) {
                      image = AssetImage(snapshot.data!.photoUrl);
                    } else {
                      image = NetworkImage(snapshot.data!.photoUrl);
                    }

                    return Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: image,
                          radius: 70,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          snapshot.data!.displayName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(snapshot.data!.email),
                            Text(snapshot.data!.phone),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
