import 'pull_request.dart';
import 'commit.dart';
import 'issue.dart';

class Repo {
  String name;
  Future<List<Issue>> issues;
  Future<List<PullRequest>> pullRequests;
  Future<List<Commit>> commits;

  Repo(this.name, this.issues, this.pullRequests, this.commits);

  toString() => name;
}
