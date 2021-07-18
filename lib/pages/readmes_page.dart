import 'dart:convert';

import 'package:align/components/api_doc.dart';
import 'package:align/models/microservice.dart';
import 'package:align/models/repo_file.dart';
import 'package:align/models/swagger.dart';
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

class ReadmesPage extends StatefulWidget {
  ReadmesPage({Key? key}) : super(key: key);

  @override
  _ReadmesPageState createState() => _ReadmesPageState();
}

class _ReadmesPageState extends State<ReadmesPage> {
  List<Microservice> _microservices = [];
  Microservice? _selectedMicroservice;
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
    if (storage.microservices.length > 0) {
      setState(() {
        _microservices = storage.microservices;
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
      drawer: Drawer(
        child: buildDrawerContents(context),
      ),
      body: _microservices.length == 0 && _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Row(
                children: [
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
    if (_selectedMicroservice == null) return buildDrawerContents(context);
    return Markdown(
      data: _selectedMicroservice!.readme.readme
          .replaceAll(RegExp(r'\|\s+$', multiLine: true), "|"),
      imageBuilder: githubImageBuilder,
      onTapLink: ((text, href, title) {
        if (href == null) return;
        if (href.startsWith("http")) {
          launch(href.toString());
        } else {
          launch("${_selectedMicroservice!.repo.url}/tree/master/$href");
        }
      }),
    );
  }

  buildApiContent() {
    if (_selectedMicroservice == null) return Container();
    var swaggerService = SwaggerService();
    return FutureBuilder<Swagger?>(
      future: swaggerService.getSwagger(_selectedMicroservice!.swaggerUrl),
      builder: (context, swagger) {
        if (swagger.hasData) {
          return swagger.data != null ? ApiDoc(swagger.data!) : Container();
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
      future: getGithubImageBase64(_selectedMicroservice?.repo.name, uri),
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

  buildDrawerContents(context) {
    var teams = _microservices.map((it) => it.metadata.team).toSet().toList();
    return ListView(
      children: teams.expand((team) {
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
                  leading: getLeadingIcon(it),
                  title: Text(it.repo.name),
                  subtitle: Text(it.readme.purpose),
                  selected: _selectedMicroservice != null
                      ? _selectedMicroservice?.repo.name == it.repo.name
                      : false,
                  onTap: () {
                    setState(() {
                      _selectedMicroservice = it;
                    });
                  },
                ),
              )
              .toList(),
        ];
      }).toList(),
    );
  }

  buildActions(BuildContext context) {
    return [
      _selectedMicroservice != null
          ? IconButton(
              onPressed: () {
                launch(_selectedMicroservice!.repo.url);
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

  getLeadingIcon(Microservice it) {
    Map<String, Icon> icons = {
      "service": Icon(Icons.filter_tilt_shift),
      "dashboard": Icon(Icons.dashboard),
      "producer": Icon(Icons.send),
      "android": Icon(Icons.android),
      "bff": Icon(Icons.door_front)
    };
    if (!icons.containsKey(it.metadata.serviceType)) return Icon(Icons.help);
    return icons[it.metadata.serviceType];
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
