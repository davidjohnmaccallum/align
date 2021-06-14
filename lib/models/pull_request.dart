import 'package:github/github.dart' as gh;

import '../utils.dart';

class PullRequest {
  String message;
  String author;
  String ago;

  PullRequest.fromGitHub(gh.PullRequest pr)
      : message = [pr.title, pr.body].where((it) => it != null).join("\n"),
        author = pr.user?.name ?? '',
        ago = getAgo(pr.createdAt);
}
