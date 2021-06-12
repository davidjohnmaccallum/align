import 'package:align/components/repo.dart';
import 'package:flutter/material.dart';

class TeamWidget extends StatelessWidget {
  final String title;
  final List<String> repoNames;

  const TeamWidget({Key? key, required this.title, required this.repoNames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        children: [
          Container(
            child: Text(title),
            alignment: Alignment.center,
            height: 40,
          ),
          ...repoNames.map((repoName) => RepoWidget(title: repoName))
        ],
      ),
    );
  }
}
