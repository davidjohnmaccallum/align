import 'package:align/models/microservice.dart';
import 'package:align/pages/settings_page.dart';
import 'package:align/services/microservice_service.dart';
import 'package:align/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReadmesPage extends StatefulWidget {
  ReadmesPage({Key? key}) : super(key: key);

  @override
  _ReadmesPageState createState() => _ReadmesPageState();
}

class _ReadmesPageState extends State<ReadmesPage> {
  List<Microservice>? _microservices;
  Microservice? _selectedMicroserice;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    setState(() {
      _microservices = null;
    });
    var settings = await SettingsService.getInstance();
    var microserviceService = MicroserviceService.fromSettings(settings);
    var microservices = await microserviceService.listMicroservices();
    microservices.sort((a, b) => a.repo.name.compareTo(b.repo.name));
    setState(() {
      _microservices = microservices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Readme"),
        actions: buildActions(context),
      ),
      body: _microservices != null
          ? Container(
              child: Row(
                children: [
                  buildNav(context),
                  Expanded(
                    child: Column(
                      children: [
                        buildContentActionBar(),
                        buildContent(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  buildContent() {
    return Expanded(
      child: Markdown(
        data: _selectedMicroserice != null
            ? _selectedMicroserice!.readme.readme
                .replaceAll(RegExp(r'\|\s+$', multiLine: true), "|")
            : "",
        imageBuilder: (uri, title, alt) =>
            Image(image: CachedNetworkImageProvider(uri.toString())),
      ),
    );
  }

  buildContentActionBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
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
    ];
  }

  buildNavItems(context) {
    if (_microservices == null) return [];
    var teams = _microservices!.map((it) => it.metadata.team).toSet().toList();

    return teams.expand((team) {
      return [
        ListTile(
          title: Text(
            team,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        ..._microservices!
            .where((it) => it.metadata.team == team)
            .map(
              (it) => ListTile(
                title: Text(it.repo.name),
                subtitle: Text(it.metadata.description),
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
}
