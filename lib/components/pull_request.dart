import 'package:flutter/material.dart';

class PullRequestTile extends StatelessWidget {
  final String title;
  final String author;
  final String age;

  const PullRequestTile({
    Key? key,
    required this.title,
    required this.author,
    required this.age,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
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
                Text(author),
                Text(age),
              ],
            ),
          )
        ],
      ),
    );
  }
}
