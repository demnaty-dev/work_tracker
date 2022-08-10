import 'package:flutter/material.dart';

import '../constants/palette.dart';
import '../features/inbox/pages/inbox.dart';
import '../features/projects/pages/projects.dart';
import '../features/settings/pages/setting.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    const Projects(),
    const Inbox(),
    const Setting(),
  ];

  final bucket = PageStorageBucket();

  Widget materialButtonBuilder(String title, IconData icon, int index) {
    return Expanded(
      child: MaterialButton(
        minWidth: 40,
        onPressed: () {
          setState(() {
            currentTab = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: currentTab == index ? primaryColor : textField,
            ),
            Text(
              title,
              style: TextStyle(
                color: currentTab == index ? primaryColor : textField,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageStorage(
          bucket: bucket,
          child: screens[currentTab],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              materialButtonBuilder('Home', Icons.home, 0),
              materialButtonBuilder('Inbox', Icons.mail, 1),
              materialButtonBuilder('Setting', Icons.settings, 2),
            ],
          ),
        ),
      ),
    );
  }
}
