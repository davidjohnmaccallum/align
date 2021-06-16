import 'package:align/components/repo_widget.dart';
import 'package:flutter/material.dart';

class TeamWidget extends StatelessWidget {
  final String title;
  final List<String> repoNames;

  const TeamWidget({Key? key, required this.title, required this.repoNames})
      : super(key: key);

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
                title,
                style: Theme.of(context).textTheme.headline2,
              ),
              alignment: Alignment.center,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: repoNames
                  .map((repoName) => RepoWidget(repoName: repoName))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
