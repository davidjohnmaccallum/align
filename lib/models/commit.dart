import '../utils.dart';

class Commit {
  String sha;
  String message;
  String url;
  String author;
  String avatar;
  String ago;

  Commit.fromJson(Map<String, dynamic> commit)
      : sha = commit['sha'] ?? '',
        message = commit['commit']?['message'] ?? '',
        url = commit['html_url'] ?? '',
        author = commit['commit']?['author']?['name'] ?? '',
        avatar = commit['author']?['avatar_url'] ?? '',
        ago = getAgoFromStr(commit['commit']?['author']?['date']);

  toString() => "When: $ago. Who: $author. What: $message";
}
