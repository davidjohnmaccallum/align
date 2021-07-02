import 'package:align/components/list_item_widget.dart';
import 'package:align/models/issue.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      text: issue.key,
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          launch(issue.url);
                        },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/icons/jira.svg',
                    semanticsLabel: 'JIRA Logo',
                  ),
                ),
              ],
            ),
          ),
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
                    backgroundImage: issue.reporterAvatar,
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
