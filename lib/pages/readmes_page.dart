import 'dart:convert';

import 'package:align/models/microservice.dart';
import 'package:align/pages/settings_page.dart';
import 'package:align/services/microservice_service.dart';
import 'package:align/services/settings_service.dart';
import 'package:align/services/storage_service.dart';
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
    var storage = await StorageService.getInstance();
    var savedData = storage.microservices;
    if (savedData.length > 0) {
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
                    child: Stack(
                      children: [
                        buildContentActionBar(),
                        buildContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  buildContent() {
    // TODO: Make raw.githubusercontent.com imageBuilder
    return Markdown(
      data: _selectedMicroserice != null
          ? _selectedMicroserice!.readme.readme
              .replaceAll(RegExp(r'\|\s+$', multiLine: true), "|")
          : "",
      imageBuilder: (uri, title, alt) =>
          Image(image: CachedNetworkImageProvider(uri.toString())),
    );
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
