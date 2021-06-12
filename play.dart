import 'dart:io';

import 'package:github/github.dart';

final String token = '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';

void main() async {
  print('Hello, World!');

  try {
    GitHub github = GitHub(auth: Authentication.withToken(token));

    // Get the repo
    Repository repo = await github.repositories
        .getRepository(RepositorySlug('mrdelivery', 'log-order-injection-svc'));
    print(repo);

    // Get the master commits
    github.repositories
        .listCommits(RepositorySlug('mrdelivery', 'log-order-injection-svc'))
        .listen((event) {
      print(event.commit?.message);
      print('----');
    });

    // List the orgs repos
    // github.repositories.listOrganizationRepositories('mrdelivery').listen(
    //   (event) {
    //     print(event);
    //   },
    //   onError: (err) {
    //     print(err);
    //   },
    // );
  } catch (err) {
    print(err);
  }
}
