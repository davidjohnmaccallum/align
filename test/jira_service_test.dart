import 'dart:io';

import 'package:align/services/jira_service.dart';
import 'package:test/test.dart';

void main() {
  var username = Platform.environment['ALIGN_JIRA_USERNAME'] ?? '';
  var password = Platform.environment['ALIGN_JIRA_PASSWORD'] ?? '';

  setUp(() {
    expect(username, isNotEmpty);
    expect(password, isNotEmpty);
  });

  test('Get issues', () async {
    var jiraService = JiraService(username, password);
    var issues = await jiraService.findIssuesByLabel('log-order-injection-svc');
    // print(issues);
    expect(issues.length, greaterThan(0));
  });
}
