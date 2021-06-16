import 'package:align/models/commit.dart';
import 'package:flutter/material.dart';

class CommitTile extends StatelessWidget {
  final Commit commit;

  const CommitTile({
    Key? key,
    required this.commit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Container(
          padding: EdgeInsets.all(9.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(commit.message, overflow: TextOverflow.visible),
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
                        backgroundImage: NetworkImage(commit.avatar),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(commit.author),
                        Text(commit.ago),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
