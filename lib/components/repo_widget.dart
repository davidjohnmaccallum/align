import 'package:align/components/commit_tile.dart';
import 'package:align/models/commit.dart';
import 'package:align/models/issue.dart';
import 'package:align/models/repo.dart';
import 'package:align/models/pull_request.dart';

import 'package:align/components/pull_request_tile.dart';
import 'package:align/components/issue_tile.dart';
import 'package:flutter/material.dart';

class RepoWidget extends StatefulWidget {
  final Repo repo;

  const RepoWidget(this.repo, {Key? key}) : super(key: key);

  @override
  _RepoWidgetState createState() => _RepoWidgetState();
}

class _RepoWidgetState extends State<RepoWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Text(
                  widget.repo.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                alignment: Alignment.center,
              ),
              getIssuesWidget(),
              getPullRequestsWidget(),
              getCommitsWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget getIssuesWidget() {
    return FutureBuilder<List<Issue>>(
      future: widget.repo.issues,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(child: Text("${snapshot.error}"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: (snapshot.data ?? []).map((issue) {
            return IssueTile(issue: issue);
          }).toList(),
        );
      },
    );
  }

  Widget getPullRequestsWidget() {
    return FutureBuilder<List<PullRequest>>(
      future: widget.repo.pullRequests,
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
      future: widget.repo.commits,
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
