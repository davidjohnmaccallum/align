import '../utils.dart';

class PullRequest {
  String title;
  String author;
  String avatar;
  String ago;

  PullRequest.fromGitHub(Map<String, dynamic> pull)
      : title = pull['title'] ?? '',
        author = pull['user']?['login'] ?? '',
        avatar = pull['user']?['avatar_url'] ?? '',
        ago = getAgoFromStr(pull['created_at']);
}
