import 'package:align/components/team_widget.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: getTeamsWidget(),
          ),
        ),
      ),
    );
  }

  Widget getTeamsWidget() {
    return FutureBuilder<List<Widget>>(
      future: getTeams(),
      initialData: [],
      builder: (context, snapshot) {
        return Row(
          children: snapshot.data ?? [],
        );
      },
    );
  }

  Future<List<Widget>> getTeams() async {
    return [
      TeamWidget(
        title: 'Tracking',
        repoNames: [
          'log-api-bff',
          'log-waybill-svc',
          'log-order-injection-svc',
          'log-trip-injection-svc',
          'lft-parcel-svc',
          'order_service',
          'order-tracking_service',
          'log-courier-injection-svc',
          'log-courier-callback-svc',
          'log-courier-api-bff',
          'log-courier-callback-producer',
          'log-delivery-tracking-svc',
          'log-delivery-event-producer',
          'log-fnb-bff'
        ],
      ),
    ];
  }
}
