import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../utils.dart';

class Issue {
  String key;
  String summary;
  String url;
  String reporterName;
  NetworkImage reporterAvatar;
  String ago;

  Issue.fromJson(issue)
      : key = issue['key'] ?? '',
        summary = issue['fields']?['summary'] ?? '',
        url = issue['key'] != null
            ? "https://${getHostName(issue['self'])}/jira/browse/${issue['key']}"
            : '',
        reporterName = issue['fields']?['reporter']?['displayName'] ?? '',
        reporterAvatar =
            issue['fields']?['reporter']?['avatarUrls']?['48x48'] != null
                ? getReporterAvatar(
                    issue['fields']?['reporter']?['avatarUrls']?['48x48'])
                : NetworkImage(''),
        ago = getAgoFromStr(issue['fields']?['created']);

  toString() =>
      "When: $ago. Who: $reporterName. Avatar: $reporterAvatar. What: $summary.";

  static String getHostName(String url) {
    return Uri.parse(url).host;
  }

  static NetworkImage getReporterAvatar(String url) {
    var u = Platform.environment['ALIGN_JIRA_USERNAME'] ?? '';
    var p = Platform.environment['ALIGN_JIRA_PASSWORD'] ?? '';
    return NetworkImage(url, headers: {
      HttpHeaders.authorizationHeader:
          'Basic ' + base64Encode(utf8.encode('$u:$p')),
    });
  }
}
