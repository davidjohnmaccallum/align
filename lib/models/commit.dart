import '../utils.dart';

class Commit {
  String message;
  String author;
  String ago;

  Commit.fromGitHub(Map<String, dynamic> commit)
      : message = commit['commit']?['message'] ?? '',
        author = commit['commit']?['author']?['name'] ?? '',
        ago = getAgoFromStr(commit['commit']?['author']?['date']);

  toString() => "When: $ago. Who: $author. What: $message";
}
