import '../utils.dart';

class Issue {
  String summary;
  String reporterName;
  String reporterAvatar;
  String ago;

  Issue.fromJson(issue)
      : summary = issue['fields']?['summary'] ?? '',
        reporterName = issue['fields']?['reporter']?['displayName'] ?? '',
        reporterAvatar =
            issue['fields']?['reporter']?['avatarUrls']?['32x32'] ?? '',
        ago = getAgoFromStr(issue['fields']?['created']);

  toString() =>
      "When: $ago. Who: $reporterName. Avatar: $reporterAvatar. What: $summary.";
}
