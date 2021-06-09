import 'package:flutter/material.dart';

class Commit extends StatelessWidget {
  const Commit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  "Cupidatat esse velit do nulla Lorem elit qui veniam consectetur quis.",
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
                Text("David"),
                Text("2d"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
