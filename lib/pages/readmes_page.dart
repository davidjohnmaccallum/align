import 'dart:convert';

import 'package:align/models/readmes.dart';
import 'package:align/pages/settings_page.dart';
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
    var storage = await StorageService.getInstance();
    storage.readmes = readmes;
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
      drawer: Drawer(
        child: buildDrawerContents(context),
      ),
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: buildReadmeContent(),
            ),
          ],
        ),
      ),
    );
  }

  buildReadmeContent() {
    if (_selectedReadme == null) return buildDrawerContents(context);
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
        return Markdown(
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
        );
      },
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

  buildDrawerContents(context) {
    var teams = _model.readmes.map((it) => it.team).toSet().toList();
    return ListView(
      children: teams.expand((team) {
        return [
          ListTile(
            title: Text(
              team,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          ..._model.readmes
              .where((readme) => readme.team == team)
              .map(
                (readme) => ListTile(
                  leading: getLeadingIcon(readme.componentType),
                  title: Text(readme.repoName),
                  subtitle: getSubtitle(readme),
                  selected: _selectedReadme != null
                      ? _selectedReadme?.repoName == readme.repoName
                      : false,
                  onTap: () {
                    setState(() {
                      _selectedReadme = readme;
                    });
                  },
                ),
              )
              .toList(),
        ];
      }).toList(),
    );
  }

  getSubtitle(Readme readme) {
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

  getLeadingIcon(String componentType) {
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
