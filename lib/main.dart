import 'dart:io';

import 'package:align/components/container_widget.dart';
import 'package:flutter/material.dart';

import 'components/team_widget.dart';

void main() async {
  if (Platform.environment['ALIGN_GITHUB_TOKEN'] == null)
    throw Exception("ALIGN_GITHUB_TOKEN env var not set");
  if (Platform.environment['ALIGN_GITHUB_ORG'] == null)
    throw Exception("ALIGN_GITHUB_ORG env var not set");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: ContainerWidget(),
    );
  }
}
