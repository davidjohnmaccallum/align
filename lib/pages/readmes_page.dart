import 'dart:convert';

import 'package:align/models/microservice.dart';
import 'package:align/models/repo_file.dart';
import 'package:align/pages/settings_page.dart';
import 'package:align/services/feature_flags_service.dart';
import 'package:align/services/github_service.dart';
import 'package:align/services/microservice_service.dart';
import 'package:align/services/settings_service.dart';
import 'package:align/services/storage_service.dart';
import 'package:align/services/swagger_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ReadmesPage extends StatefulWidget {
  ReadmesPage({Key? key}) : super(key: key);

  @override
  _ReadmesPageState createState() => _ReadmesPageState();
}

class _ReadmesPageState extends State<ReadmesPage> {
  List<Microservice> _microservices = [];
  Microservice? _selectedMicroserice;
  bool _loading = false;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    print("load");
    var settings = await SettingsService.getInstance();
    if (!settings.hasRequiredSettings()) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
    }

    var storage = await StorageService.getInstance();
    var savedData = storage.microservices;
    if (savedData.length > 0) {
      setState(() {
        _microservices = storage.microservices;
        _selectedMicroserice = storage.microservices[0];
      });
    } else {
      reload();
    }
  }

  void reload() async {
    print("reload");
    setState(() {
      _loading = true;
    });

    var settings = await SettingsService.getInstance();
    var microserviceService = MicroserviceService.fromSettings(settings);
    var microservices = await microserviceService.listMicroservices();
    microservices.sort((a, b) => a.repo.name.compareTo(b.repo.name));

    var storage = await StorageService.getInstance();
    storage.microservices = microservices;

    setState(() {
      _microservices = microservices;
      _selectedMicroserice = storage.microservices[0];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var featureFlags = FeatureFlagsService();
    return Scaffold(
      appBar: AppBar(
        title: Text("Readme"),
        actions: buildActions(context),
      ),
      body: _microservices.length == 0 && _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Row(
                children: [
                  buildNav(context),
                  Expanded(
                    child: featureFlags.apiDocs
                        ? buildTabbedContent()
                        : buildReadmeContent(),
                  ),
                ],
              ),
            ),
    );
  }

  buildReadmeContent() {
    if (_selectedMicroserice == null) return Container();
    return Markdown(
      data: _selectedMicroserice!.readme.readme
          .replaceAll(RegExp(r'\|\s+$', multiLine: true), "|"),
      imageBuilder: githubImageBuilder,
      onTapLink: (text, href, title) => launch(href.toString()),
    );
  }

  buildApiContent() {
    if (_selectedMicroserice == null) return Container();
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getSwagger(_selectedMicroserice!.swaggerUrl),
      builder: (context, swagger) {
        if (swagger.hasData) {
          var swaggerService = SwaggerService();
          return swagger.data != null
              ? Markdown(
                  data: swaggerService.toMarkdown(swagger.data!),
                  imageBuilder: githubImageBuilder,
                )
              : Container();
        }
        if (swagger.hasError) {
          return Center(child: Text("Error: ${swagger.error}"));
        }
        return Container();
      },
    );
  }

  Widget githubImageBuilder(uri, title, alt) {
    return FutureBuilder<String>(
      future: getGithubImageBase64(_selectedMicroserice?.repo.name, uri),
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

  Future<Map<String, dynamic>?> _getSwagger(String url) async {
    var res = await http.get(Uri.parse(url));
    if (res.statusCode < 300) {
      return jsonDecode(res.body);
    }
  }

  Map<String, String> imageUrlCache = {};

  Future<String> getGithubImageBase64(repoName, path) async {
    String? cachedImageUrl = imageUrlCache["$repoName/$path"];
    if (cachedImageUrl == null) {
      var settings = await SettingsService.getInstance();
      var github = GitHubService.fromSettings(settings);
      RepoFile? file = await github.getFile(repoName, path.toString());
      print("File: $file");
      imageUrlCache["$repoName/$path"] =
          file?.content.replaceAll(RegExp(r"\n"), "") ?? "";
    }
    return imageUrlCache["$repoName/$path"]!;
  }

  buildContentActionBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _selectedMicroserice != null
                ? IconButton(
                    onPressed: () {
                      launch(_selectedMicroserice!.repo.url);
                    },
                    icon: SvgPicture.asset('assets/icons/octocat.svg'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  buildNav(context) {
    return Container(
      width: 300,
      child: ListView(
        children: buildNavItems(context),
      ),
    );
  }

  buildActions(BuildContext context) {
    return [
      _selectedMicroserice != null
          ? IconButton(
              onPressed: () {
                launch(_selectedMicroserice!.repo.url);
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
          : Container(),
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

  buildNavItems(context) {
    var teams = _microservices.map((it) => it.metadata.team).toSet().toList();

    return teams.expand((team) {
      return [
        ListTile(
          title: Text(
            team,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        ..._microservices
            .where((it) => it.metadata.team == team)
            .map(
              (it) => ListTile(
                title: Text(it.repo.name),
                subtitle: Text(it.readme.purpose),
                selected: _selectedMicroserice != null
                    ? _selectedMicroserice?.repo.name == it.repo.name
                    : false,
                onTap: () {
                  setState(() {
                    _selectedMicroserice = it;
                  });
                },
              ),
            )
            .toList(),
      ];
    }).toList();
  }

  buildTabbedContent() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: "Readme"),
              Tab(text: "API"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildReadmeContent(),
            buildApiContent(),
          ],
        ),
      ),
    );
  }
}
