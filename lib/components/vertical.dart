import 'package:align/components/repo.dart';
import 'package:flutter/material.dart';

class Vertical extends StatelessWidget {
  const Vertical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      //padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        children: [
          Container(
            child: Text("Title"),
            alignment: Alignment.center,
            height: 40,
          ),
          Row(
            children: [
              Repo(),
              Repo(),
              Repo(),
              Repo(),
            ],
          ),
        ],
      ),
    );
  }
}
