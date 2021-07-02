import 'package:align/components/team_widget.dart';
import 'package:align/models/microservice.dart';
import 'package:align/models/team.dart';
import 'package:align/pages/settings_page.dart';
import 'package:align/services/github_service.dart';
import 'package:align/services/jira_service.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _teams = [];

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    var trackingRepos = [
      'log-api-bff',
      'log-waybill-svc',
      'log-order-injection-svc',
      'log-trip-injection-svc',
      'lft-parcel-svc',
      'order_service',
      'order-tracking_service',
      'log-courier-injection-svc',
      'log-courier-callback-svc',
      'log-courier-api-bff',
      'log-courier-callback-producer',
      'log-delivery-tracking-svc',
      'log-delivery-event-producer',
      'log-fnb-bff'
    ];

    var tracking = Team('Tracking', []);

    var jiraService = JiraService();
    var gitHubService = GitHubService();

    for (int i = 0; i < trackingRepos.length; i++) {
      var repo = trackingRepos[i];
      var issues = jiraService.findIssuesByLabel(repo);
      var pullRequests = gitHubService.listPullRequests(repo, 100);
      var commits = gitHubService.listCommits(repo, 'develop', 100);
      var microserivce = Microservice(repo, issues, pullRequests, commits);
      tracking.microservices.add(microserivce);
    }

    setState(() {
      _teams = [tracking];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Align"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              load();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Material(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _teams.map((team) => TeamWidget(team)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
