import 'package:align/models/swagger.dart';
import 'package:flutter/material.dart';

class ApiDoc extends StatelessWidget {
  final Swagger _swagger;

  const ApiDoc(this._swagger, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _swagger.operations
            .map<Widget>((operation) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${operation.verb} ${operation.path}",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(operation.description),
                    Text(
                      "Parameters",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: operation.parameters
                          .map((param) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(param.name),
                                  Text(param.description),
                                ],
                              ))
                          .toList(),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
