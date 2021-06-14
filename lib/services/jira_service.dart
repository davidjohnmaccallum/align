import 'package:align/models/issue.dart';

class JiraService {
  Future<List<Issue>> getIssuesByLabel(String label) async {
    //https://jira.takealot.com/jira/rest/api/2/search?jql=labels%20%3D%20popi-data-deletion
    return [];
  }
}
