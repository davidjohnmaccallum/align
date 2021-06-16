import 'package:align/components/list_item_widget.dart';
import 'package:align/models/pull_request.dart';
import 'package:flutter/material.dart';

class PullRequestTile extends StatelessWidget {
  final PullRequest pull;

  const PullRequestTile({
    Key? key,
    required this.pull,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListItemWidget(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  pull.title,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
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
                    backgroundImage: NetworkImage(pull.avatar),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(pull.author),
                    Text(pull.ago),
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
