import 'package:align/services/settings_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _gitHubTokenController = TextEditingController();
  var _gitHubOrganisationController = TextEditingController();
  var _jiraUsernameController = TextEditingController();
  var _jiraPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
        future: Future.wait([
          SettingsService.getInstance(),
          PackageInfo.fromPlatform(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SettingsService settingsService = snapshot.data?[0];
            PackageInfo packageInfo = snapshot.data?[1];
            _gitHubTokenController.text = settingsService.getGitHubToken();
            _gitHubOrganisationController.text =
                settingsService.getGitHubOrganisation();
            _jiraUsernameController.text = settingsService.getJiraUsername();
            _jiraPasswordController.text = settingsService.getJiraPassword();

            _gitHubTokenController.addListener(() {
              settingsService.setGitHubToken(_gitHubTokenController.text);
            });
            _gitHubOrganisationController.addListener(() {
              settingsService
                  .setGitHubOrganisation(_gitHubOrganisationController.text);
            });
            _jiraUsernameController.addListener(() {
              settingsService.setJiraUsername(_jiraUsernameController.text);
            });
            _jiraPasswordController.addListener(() {
              settingsService.setJiraPassword(_jiraPasswordController.text);
            });

            return Stack(
              children: [
                Positioned(
                  child: Text("Ver: ${packageInfo.version}"),
                  bottom: 30,
                  right: 30,
                ),
                Container(
                  margin: const EdgeInsets.all(50.0),
                  child: IconButton(
                    iconSize: 50,
                    alignment: Alignment.center,
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 700,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              "Settings",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          buildSetting(
                            "GitHub Token",
                            buildGitHubTokenDetails(context),
                            "Enter GitHub token",
                            _gitHubTokenController,
                            context,
                          ),
                          buildSetting(
                            "GitHub Organisation",
                            Text(
                                "The GitHub organisation to which your repos belong. You can find this in your GitHub repo URL here: https://github.com/organisation-name/repo-name."),
                            "Enter GitHub organisation",
                            _gitHubOrganisationController,
                            context,
                          ),
                          // buildSetting(
                          //   "JIRA Username",
                          //   Text("The JIRA username."),
                          //   "Enter JIRA username",
                          //   _jiraUsernameController,
                          //   context,
                          // ),
                          // buildSetting(
                          //   "JIRA Password",
                          //   Text(
                          //       "The JIRA password. Don't worry, this is only stored and used locally to access the JIRA issues for your microservices."),
                          //   "Enter JIRA password",
                          //   _jiraPasswordController,
                          //   context,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildSetting(String name, Widget details, String hintText,
      TextEditingController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
            controller: controller,
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
}
