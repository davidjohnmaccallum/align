import 'dart:io';

import 'package:align/components/commit_tile.dart';
import 'package:align/models/commit.dart';
import 'package:align/models/issue.dart';
import 'package:align/models/pull_request.dart';
import 'package:align/services/github_service.dart';

import 'package:align/components/pull_request_tile.dart';
import 'package:align/components/issue_tile.dart';
import 'package:align/services/jira_service.dart';
import 'package:flutter/material.dart';

class RepoWidget extends StatefulWidget {
  final String repoName;

  const RepoWidget({Key? key, required this.repoName}) : super(key: key);

  @override
  _RepoWidgetState createState() => _RepoWidgetState();
}

class _RepoWidgetState extends State<RepoWidget> {
  GitHubService gitHubService =
      GitHubService(Platform.environment['ALIGN_GITHUB_TOKEN'] ?? '');
  JiraService jiraService = JiraService();

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
    return FutureBuilder<List<Issue>>(
      future: jiraService.getIssuesByLabel(widget.repoName),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(child: Text("${snapshot.error}"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: (snapshot.data ?? []).map((pr) {
            return IssueTile(
              title: pr.message,
              author: pr.author,
              age: pr.ago,
            );
          }).toList(),
        );
      },
    );
  }

  Widget getPullRequestsWidget() {
    return FutureBuilder<List<PullRequest>>(
      future: gitHubService.listPullRequests(
          Platform.environment['ALIGN_GITHUB_ORG'] ?? '', widget.repoName, 10),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(child: Text("${snapshot.error}"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: (snapshot.data ?? []).map((pull) {
            return PullRequestTile(pull: pull);
          }).toList(),
        );
      },
    );
  }

  Widget getCommitsWidget() {
    return FutureBuilder<List<Commit>>(
      future: gitHubService.listCommits(
          Platform.environment['ALIGN_GITHUB_ORG'] ?? '',
          widget.repoName,
          'develop',
          10),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(child: Text("${snapshot.error}"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: (snapshot.data ?? []).map((commit) {
            return CommitTile(commit: commit);
          }).toList(),
        );
      },
    );
  }
}
