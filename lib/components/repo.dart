import 'package:align/components/pull_request.dart';
import 'package:align/components/ticket.dart';
import 'package:flutter/material.dart';

import 'commit.dart';

class Repo extends StatelessWidget {
  final String title;

  const Repo({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
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
            child: Text(title),
            alignment: Alignment.center,
            height: 40,
          ),
          Ticket(title: 'Refactor data model'),
          Ticket(title: 'Add deleteWaybill method', owner: 'Aphiwe'),
          PullRequest(title: 'Add updateWaybill method', author: 'Louis', age: '3h'),
          PullRequest(title: 'Send BI event', author: 'Aphiwe', age: '8h'),
          Commit(title: 'Add injectWaybill method', author: 'Aphiwe', age: '3d'),
          Commit(title: 'Add getWaybill metric', author: 'Aphiwe', age: '4d'),
          Commit(title: 'Tweak CPU settings', author: 'Aphiwe', age: '6d'),
          Commit(title: 'Tweak scaling settings', author: 'Aphiwe', age: '8d'),
        ],
      ),
    );
  }
}
