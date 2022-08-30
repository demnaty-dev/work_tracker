import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_tracker/src/features/inbox/services/inbox_services.dart';
import 'package:work_tracker/src/features/profile/services/profile_service.dart';
import 'package:work_tracker/src/pages/home.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String _whatGoingOn = 'start';

  Future<void> _initUserProfile() async {
    await context.read<ProfileService?>()!.userModel;
  }

  Future<void> _initUserInboxes() async {
    await context.read<InboxServices?>()!.fetchInboxesFromCache(false);
  }

  void _loadHomePage() {
    Navigator.pushReplacementNamed(context, Home.routeName);
  }

  Future<void> _loadingHomePage() async {
    setState(() => _whatGoingOn = 'loading profile data');
    await _initUserProfile();
    setState(() => _whatGoingOn = 'loading inboxes data');
    await _initUserInboxes();

    setState(() => _whatGoingOn = 'Done');
    await Future.delayed(const Duration(seconds: 1));
    _loadHomePage();
  }

  @override
  void didChangeDependencies() {
    _loadingHomePage();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(_whatGoingOn),
          ],
        ),
      ),
    );
  }
}