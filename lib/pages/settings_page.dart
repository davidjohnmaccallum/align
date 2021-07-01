import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Settings",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              buildSetting(
                "GitHub Token",
                buildGitHubTokenDetails(context),
                "Enter GitHub token",
                context,
              ),
              buildSetting(
                "GitHub Organisation",
                buildGitHubOrganisationDetails(context),
                "Enter GitHub organisation",
                context,
              ),
              buildSetting(
                "JIRA Username",
                buildJiraUsernameDetails(context),
                "Enter JIRA username",
                context,
              ),
              buildSetting(
                "JIRA Password",
                buildJiraPasswordDetails(context),
                "Enter JIRA password",
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSetting(
      String name, Widget details, String hintText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: details,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGitHubTokenDetails(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Click ",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextSpan(
            text: "here",
            style: new TextStyle(color: Colors.blue),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                launch("https://github.com/settings/tokens/new");
              },
          ),
          TextSpan(
            text: " to create a GitHub token. The token must have ",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextSpan(
            text: "repo",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: " permissions.",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget buildGitHubOrganisationDetails(BuildContext context) => Text(
      "The GitHub organisation to which your repos belong. You can find this in your GitHub repo URL here: https://github.com/organisation-name/repo-name.");

  Widget buildJiraUsernameDetails(BuildContext context) =>
      Text("The JIRA username.");

  Widget buildJiraPasswordDetails(BuildContext context) => Text(
      "The JIRA password. Don't worry, this is only stored and used locally to access the JIRA issues for your microservices.");
}
