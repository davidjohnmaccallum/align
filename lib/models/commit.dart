import 'package:github/github.dart';

import '../utils.dart';

class Commit {
  String message;
  String author;
  String ago;

  Commit.fromGitHub(RepositoryCommit commit)
      : message = commit.commit?.message ?? '',
        author = commit.commit?.author?.name ?? '',
        ago = getAgo(commit.commit?.author?.date);
}
