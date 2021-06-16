import 'package:align/components/list_item_widget.dart';
import 'package:align/models/issue.dart';
import 'package:flutter/material.dart';

class IssueTile extends StatelessWidget {
  final Issue issue;

  const IssueTile({
    Key? key,
    required this.issue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListItemWidget(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Text(issue.summary, overflow: TextOverflow.visible),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(issue.reporterAvatar),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(issue.reporterName),
                    Text(issue.ago),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
