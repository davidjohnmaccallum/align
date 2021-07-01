import '../utils.dart';

class Issue {
  String key;
  String summary;
  String url;
  String reporterName;
  String reporterAvatar;
  String ago;

  Issue.fromJson(issue)
      : key = issue['key'] ?? '',
        summary = issue['fields']?['summary'] ?? '',
        url = issue['key'] != null
            ? "https://${getHostName(issue['self'])}/jira/browse/${issue['key']}"
            : '',
        reporterName = issue['fields']?['reporter']?['displayName'] ?? '',
        reporterAvatar =
            issue['fields']?['reporter']?['avatarUrls']?['48x48'] ?? '',
        ago = getAgoFromStr(issue['fields']?['created']);

  toString() =>
      "When: $ago. Who: $reporterName. Avatar: $reporterAvatar. What: $summary.";

  static String getHostName(String url) {
    return Uri.parse(url).host;
  }
}
