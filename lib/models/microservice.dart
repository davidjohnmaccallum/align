import 'pull_request.dart';
import 'commit.dart';
import 'issue.dart';

class Microservice {
  String name;
  Future<List<Issue>> issues;
  Future<List<PullRequest>> pullRequests;
  Future<List<Commit>> commits;

  Microservice(this.name, this.issues, this.pullRequests, this.commits);

  toString() => name;
}
