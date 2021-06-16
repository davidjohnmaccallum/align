// Import the test package and Counter class
import 'dart:io';

import 'package:align/services/jira_service.dart';
import 'package:test/test.dart';

void main() {
  var jiraService = JiraService(
      Platform.environment['ALIGN_JIRA_USERNAME'] ?? '',
      Platform.environment['ALIGN_JIRA_PASSWORD'] ?? '');

  test('Get issues', () async {
    var issues = await jiraService.findIssuesByLabel('log-order-injection-svc');
    print(issues);
    expect(issues.length, 2);
  });
}
