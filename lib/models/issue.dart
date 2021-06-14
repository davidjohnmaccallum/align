import '../utils.dart';

class Issue {
  String message;
  String author;
  String ago;

  Issue.fromJira(issue)
      : message = '',
        author = '',
        ago = getAgo(null);
}
