import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final Widget child;

  const ListItemWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Container(padding: EdgeInsets.all(9.0), child: child),
      ),
    );
  }
}
