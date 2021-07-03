import 'package:align/pages/repo_activity_page.dart';
import 'package:align/pages/settings_page.dart';
import 'package:align/services/settings_service.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<SettingsService> _settingsService = SettingsService.getInstance();

    return MaterialApp(
      title: 'Align',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<SettingsService>(
        future: _settingsService,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SettingsService settingsService = snapshot.data!;
            if (settingsService.hasRequiredSettings()) {
              return RepoActivityPage();
            } else {
              return SettingsPage();
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
