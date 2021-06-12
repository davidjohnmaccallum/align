import 'package:align/components/repo.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';

class TeamWidget extends StatelessWidget {
  final String title;
  final List<String> repoNames;

  const TeamWidget({Key? key, required this.title, required this.repoNames}) : super(key: key);

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
          getReposWidget(),
        ],
      ),
    );
  }

  Widget getReposWidget() {
    return FutureBuilder<List<RepoWidget>>(
      future: getRepos(),
      initialData: [],
      builder: (context, snapshot) {
        return Row(
          children: snapshot.data ?? [],
        );
      },
    );
  }

  Future<List<RepoWidget>> getRepos() async {
    var github = GitHub(auth: Authentication.withToken('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'));

    List<Repository> repos = [];
    for (String repoName in repoNames) {
      try {
        Repository repo = await github.repositories.getRepository(RepositorySlug('mrdelivery', repoName));
        repos.add(repo);
      } catch (err) {
        print(err);
      }
    }

    return repos.map((repo) {
      return RepoWidget(title: repo.fullName);
    }).toList();
  }
}
