import '../utils.dart';

class PullRequest {
  String title;
  String url;
  int number;
  String author;
  String avatar;
  String ago;

  PullRequest.fromJson(Map<String, dynamic> pull)
      : title = pull['title'] ?? '',
        url = pull['html_url'] ?? '',
        number = pull['number'] ?? '',
        author = pull['user']?['login'] ?? '',
        avatar = pull['user']?['avatar_url'] ?? '',
        ago = getAgoFromStr(pull['created_at']);
}
