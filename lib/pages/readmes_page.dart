import 'dart:convert';

import 'package:align/models/readmes.dart';
import 'package:align/pages/settings_page.dart';
import 'package:align/services/lint_service.dart';
import 'package:align/services/readme_service.dart';
import 'package:align/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadmesPage extends StatefulWidget {
  ReadmesPage({Key? key}) : super(key: key);

  @override
  _ReadmesPageState createState() => _ReadmesPageState();
}

class _ReadmesPageState extends State<ReadmesPage> {
  ReadmeService _service = ReadmeService();
  ReadmesModel _model = ReadmesModel([]);
  Readme? _selectedReadme;
  bool _loading = false;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    var storage = await StorageService.getInstance();
    if (storage.readmes.length > 0) {
      setState(() {
        _model = ReadmesModel(storage.readmes);
      });
    } else {
      reload();
    }
  }

  void reload() async {
    setState(() {
      _loading = true;
    });
    var readmes = await _service.listMicroserviceReadmes();
    readmes.sort((a, b) => a.repoName.compareTo(b.repoName));
    var storage = await StorageService.getInstance();
    storage.readmes = readmes;
    _service.flushReadmeCache();
    setState(() {
      _model = ReadmesModel(readmes);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Readme"),
        actions: buildActions(context),
      ),
      // drawer: Drawer(
      //   child: buildDrawer(context),
      // ),
      body: Container(
        child: Row(
          children: [
            Material(
              elevation: 10,
              child: Container(
                width: 300,
                child: buildDrawer(context),
              ),
            ),
            Expanded(
              child: buildReadme(),
            ),
          ],
        ),
      ),
    );
  }

  buildReadme() {
    //if (_selectedReadme == null) return buildDrawer(context);
    if (_selectedReadme == null)
      return Center(
        child: Icon(
          Icons.menu_book,
          size: 400,
          color: Colors.grey,
        ),
      );

    return FutureBuilder<String>(
      future: _service.getReadme(
          _selectedReadme!.repoName, _selectedReadme!.readmePath),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var linter = LintService();
        return Column(
          children: [
            linter.check(snapshot.data ?? "")
                ? Container()
                : buildLinterAdvice(
                    linter.message(snapshot.data ?? ""), context),
            Expanded(
              child: Markdown(
                data: snapshot.data ?? "",
                imageBuilder: githubImageBuilder,
                onTapLink: ((text, href, title) {
                  if (href == null) return;
                  if (href.startsWith("http")) {
                    launch(href.toString());
                  } else {
                    launch("${_selectedReadme!.repoUrl}/tree/master/$href");
                  }
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildLinterAdvice(String text, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        //  color: Colors.transparent,
      ),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 1,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => launch(
                "https://jira.takealot.com/wiki/display/LOG/Service+Documentation"),
            icon: Icon(Icons.info),
          ),
        ],
      ),
    );
  }

  Widget githubImageBuilder(Uri uri, String? title, String? alt) {
    return FutureBuilder<String>(
      future:
          _service.getReadmeImage(_selectedReadme!.repoName, uri.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
              base64.decode(base64.normalize(snapshot.data ?? "")));
        }
        if (snapshot.hasError) {
          return Text("Error loading image: ${snapshot.error}");
        }
        return Container();
      },
    );
  }

  buildDrawer(context) {
    var teams = _model.readmes.map((it) => it.team).toSet().toList();
    return ListView(
      children: teams.expand((team) {
        return [
          buildDrawerSubtitle(team, context),
          ..._model.readmes
              .where((readme) => readme.team == team)
              .map(buildDrawerItem)
              .toList(),
        ];
      }).toList(),
    );
  }

  ListTile buildDrawerSubtitle(String team, context) {
    return ListTile(
      title: Text(
        team,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buildDrawerItem(Readme readme) {
    return ListTile(
      leading: buildLeadingIcon(readme.componentType),
      title: Text(readme.repoName),
      subtitle: buildSubtitle(readme),
      trailing: buildLinterIcon(readme),
      selected: _selectedReadme != null
          ? _selectedReadme?.repoName == readme.repoName
          : false,
      onTap: () {
        setState(() {
          _selectedReadme = readme;
        });
      },
    );
  }

  buildLinterIcon(Readme readme) {
    return FutureBuilder<String>(
      future: _service.getReadme(readme.repoName, readme.readmePath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var linter = LintService();
          return linter.check(snapshot.data ?? "")
              ? Icon(Icons.thumb_up)
              : Container(
                  width: 1,
                );
        }
        return Container(
          width: 1,
        );
      },
    );
  }

  buildSubtitle(Readme readme) {
    return FutureBuilder<String>(
      future: _service.getReadme(readme.repoName, readme.readmePath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(_service.getPurpose(snapshot.data));
        }
        return Container();
      },
    );
  }

  buildActions(BuildContext context) {
    return [
      _selectedReadme != null
          ? IconButton(
              onPressed: () {
                launch(_selectedReadme!.repoUrl);
              },
              icon: SvgPicture.asset(
                'assets/icons/octocat.svg',
                color: Colors.white,
              ),
            )
          : Container(),
      !_loading
          ? IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                reload();
              },
            )
          : Container(
              width: 40,
              child: Center(
                child: SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ),
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
    ];
  }

  buildLeadingIcon(String componentType) {
    Map<String, Icon> icons = {
      "service": Icon(Icons.filter_tilt_shift),
      "dashboard": Icon(Icons.dashboard),
      "producer": Icon(Icons.send),
      "android": Icon(Icons.android),
      "bff": Icon(Icons.door_front)
    };
    if (!icons.containsKey(componentType)) return Icon(Icons.help);
    return icons[componentType];
  }
}
