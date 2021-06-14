import 'dart:io';

import 'package:align/models/commit.dart';
import 'package:align/services/github_service.dart';

import 'package:align/components/pull_request.dart';
import 'package:align/components/ticket.dart';
import 'package:flutter/material.dart';

import 'commit.dart';

class RepoWidget extends StatefulWidget {
  final String repoName;

  const RepoWidget({Key? key, required this.repoName}) : super(key: key);

  @override
  _RepoWidgetState createState() => _RepoWidgetState();
}

class _RepoWidgetState extends State<RepoWidget> {
  GitHubService gitHubService = GitHubService(Platform.environment['GITHUB_TOKEN'] ?? '');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      width: 300,
      //margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      //padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(widget.repoName),
            alignment: Alignment.center,
            height: 40,
          ),
          getTicketsWidget(),
          getPullRequestsWidget(),
          getCommitsWidget()
        ],
      ),
    );
  }

  Widget getTicketsWidget() {
    return FutureBuilder<List<TicketTile>>(
      future: getTickets(),
      initialData: [],
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: snapshot.data ?? [],
        );
      },
    );
  }

  Widget getPullRequestsWidget() {
    return FutureBuilder<List<PullRequestTile>>(
      future: getPullRequests(),
      initialData: [],
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: snapshot.data ?? [],
        );
      },
    );
  }

  Widget getCommitsWidget() {
    return FutureBuilder<List<Commit>>(
      future: gitHubService.listCommits(Platform.environment['GITHUB_ORG'] ?? '', widget.repoName, 10),
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: snapshot.data!.map((commit) {
            return CommitTile(
              title: commit.message,
              author: commit.author,
              age: commit.ago,
            );
          }).toList(),
        );
      },
    );
  }

  Future<List<TicketTile>> getTickets() async {
    return [
      TicketTile(title: 'Refactor data model'),
      TicketTile(title: 'Add deleteWaybill method', owner: 'Aphiwe'),
    ];
  }

  Future<List<PullRequestTile>> getPullRequests() async {
    return [
      PullRequestTile(title: 'Add updateWaybill method', author: 'Louis', age: '3h'),
      PullRequestTile(title: 'Send BI event', author: 'Aphiwe', age: '8h'),
    ];
  }
}
