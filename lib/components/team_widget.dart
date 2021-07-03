import 'package:align/components/repo_widget.dart';
import 'package:align/models/team.dart';
import 'package:flutter/material.dart';

class TeamWidget extends StatelessWidget {
  final Team team;

  const TeamWidget(this.team, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              child: Text(
                team.name,
                style: Theme.of(context).textTheme.headline2,
              ),
              alignment: Alignment.center,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: team.repos.map((repo) => RepoWidget(repo)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
