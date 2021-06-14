import 'package:github/github.dart' as github;

import '../utils.dart';

class PullRequest {
  String message;
  String author;
  String ago;

  PullRequest.fromGitHub(github.PullRequest pr)
      : message = '',
        author = '',
        ago = getAgo(null);
}
