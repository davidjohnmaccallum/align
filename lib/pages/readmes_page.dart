import 'package:align/models/microservice.dart';
import 'package:align/pages/settings_page.dart';
import 'package:align/services/microservice_service.dart';
import 'package:align/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: _microservices != null
          ? Container(
              child: Row(
                children: [
                  Container(
                    width: 300,
                    child: ListView(
                      children: getMicroserviceListTiles(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              _selectedMicroserice != null
                                  ? TextButton(
                                      onPressed: () {
                                        launch(_selectedMicroserice!.repo.url);
                                      },
                                      child:
                                          Text(_selectedMicroserice!.repo.url),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Markdown(
                            // data: _dummyReadme
                            data: _selectedMicroserice != null
                                ? _selectedMicroserice!.readme.readme
                                    .replaceAll(
                                        RegExp(r'\|\s+$', multiLine: true), "|")
                                : "",
                          ),
                        ),
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

  List<Widget> getMicroserviceListTiles() {
    return _microservices != null
        ? _microservices!
            .map(
              (it) => ListTile(
                title: Text(
                  it.repo.name,
                ),
                onTap: () {
                  setState(() {
                    _selectedMicroserice = it;
                  });
                },
              ),
            )
            .toList()
        : [];
  }
}
