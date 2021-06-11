import 'package:align/components/repo.dart';
import 'package:flutter/material.dart';

class Vertical extends StatelessWidget {
  final String title;

  const Vertical({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        children: [
          Container(
            child: Text(title),
            alignment: Alignment.center,
            height: 40,
          ),
          Row(
            children: [
              Repo(title: 'log-waybill-svc'),
              Repo(title: 'log-order-injection-svc'),
              Repo(title: 'log-courier-injection-svc'),
              Repo(title: 'log-courier-callback-svc'),
            ],
          ),
        ],
      ),
    );
  }
}
