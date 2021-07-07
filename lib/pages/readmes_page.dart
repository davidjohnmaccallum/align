import 'package:align/components/team_widget.dart';
import 'package:align/models/file.dart';
import 'package:align/models/readme.dart';
import 'package:align/models/repo.dart';
import 'package:align/pages/settings_page.dart';
import 'package:align/services/github_service.dart';
import 'package:align/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart';
import 'package:markdown/markdown.dart' as md;

class ReadmesPage extends StatefulWidget {
  ReadmesPage({Key? key}) : super(key: key);

  @override
  _ReadmesPageState createState() => _ReadmesPageState();
}

class _ReadmesPageState extends State<ReadmesPage> {
  var _repos = [];
  List<Readme> _readmes = [];
  List<RepoFile> _metas = [];

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    var settings = await SettingsService.getInstance();
    var github = GitHubService.fromSettings(settings);

    //var repos = await github.listReposForOrg();
    var repos = [
      Repo('log-courier-api-bff'),
    ];
    List<Readme> readmes =
        await Future.wait(repos.map((repo) => github.getReadme(repo.name)));
    List<RepoFile> metas = await Future.wait(
        repos.map((repo) => github.getFile(repo.name, '/metadata/index.yaml')));

    var reposWithMeta = metas
        .where((meta) => meta.contents.isNotEmpty)
        .map((meta) => meta.repo);
    print(reposWithMeta);

    setState(() {
      _repos =
          repos.where((repo) => reposWithMeta.contains(repo.name)).toList();
      _readmes = readmes
          .where((readme) => reposWithMeta.contains(readme.repo))
          .toList();
      _metas =
          metas.where((meta) => reposWithMeta.contains(meta.repo)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Readme"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              load();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Markdown(
          data: _readmes[0].readme.replaceAll(RegExp(r'\|\s+$'), '+'),
        ),
      ),
    );
  }
}
