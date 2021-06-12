import 'package:flutter/material.dart';

import 'components/team.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(scrollDirection: Axis.horizontal, child: getTeamsWidget()),
    );
  }

  Widget getTeamsWidget() {
    return FutureBuilder<List<TeamWidget>>(
      future: getTeams(),
      initialData: [],
      builder: (context, snapshot) {
        return Row(
          children: snapshot.data ?? [],
        );
      },
    );
  }

  Future<List<TeamWidget>> getTeams() async {
    return [
      TeamWidget(
        title: 'Tracking',
        repoNames: [
          'log-waybill-svc',
          'log-order-injection-svc',
          'log-courier-injection-svc',
        ],
      ),
      TeamWidget(
        title: 'Drivers',
        repoNames: [
          'log-waybill-svc',
          'log-order-injection-svc',
          'log-courier-injection-svc',
        ],
      ),
      TeamWidget(
        title: 'Facilities',
        repoNames: [
          'log-waybill-svc',
          'log-order-injection-svc',
          'log-courier-injection-svc',
        ],
      ),
    ];
  }
}
