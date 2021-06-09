import 'package:flutter/material.dart';

import 'commit.dart';

class Repo extends StatelessWidget {
  const Repo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      //margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      //padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text("Title"),
            alignment: Alignment.center,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
            ),
          ),
          Commit(),
          Commit(),
          Commit(),
          Commit(),
        ],
      ),
    );
  }
}
