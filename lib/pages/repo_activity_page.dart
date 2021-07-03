import 'package:align/components/team_widget.dart';
import 'package:align/models/repo.dart';
import 'package:align/models/team.dart';
import 'package:align/pages/settings_page.dart';
import 'package:flutter/material.dart';

class RepoActivityPage extends StatefulWidget {
  RepoActivityPage({Key? key}) : super(key: key);

  @override
  _RepoActivityPageState createState() => _RepoActivityPageState();
}

class _RepoActivityPageState extends State<RepoActivityPage> {
  var _teams = [];

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    var trackingRepoNames = [
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

    for (int i = 0; i < trackingRepoNames.length; i++) {
      var repoName = trackingRepoNames[i];
      // var issues = jiraService.findIssuesByLabel(repoName);
      // var pullRequests = gitHubService.listPullRequests(repoName, 100);
      // var commits = gitHubService.listCommits(repoName, 'develop', 100);
      var repo = Repo(repoName);
      tracking.repos.add(repo);
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
