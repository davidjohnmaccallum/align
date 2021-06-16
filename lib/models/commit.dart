import '../utils.dart';

class Commit {
  String message;
  String author;
  String avatar;
  String ago;

  Commit.fromJson(Map<String, dynamic> commit)
      : message = commit['commit']?['message'] ?? '',
        author = commit['commit']?['author']?['name'] ?? '',
        avatar = commit['author']?['avatar_url'] ?? '',
        ago = getAgoFromStr(commit['commit']?['author']?['date']);

  toString() => "When: $ago. Who: $author. What: $message";
}
