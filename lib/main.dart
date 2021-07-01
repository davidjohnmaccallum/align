import 'dart:io';

import 'package:align/pages/main_page.dart';
import 'package:align/pages/settings_page.dart';
import 'package:flutter/material.dart';

void main() async {
  if (Platform.environment['ALIGN_GITHUB_TOKEN'] == null)
    throw Exception("ALIGN_GITHUB_TOKEN env var not set");
  if (Platform.environment['ALIGN_GITHUB_ORG'] == null)
    throw Exception("ALIGN_GITHUB_ORG env var not set");
  if (Platform.environment['ALIGN_JIRA_USERNAME'] == null)
    throw Exception("ALIGN_JIRA_USERNAME env var not set");
  if (Platform.environment['ALIGN_JIRA_PASSWORD'] == null)
    throw Exception("ALIGN_JIRA_PASSWORD env var not set");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Align',
      theme: ThemeData.light(),
      home: MainPage(),
      // home: SettingsPage(),
    );
  }
}
