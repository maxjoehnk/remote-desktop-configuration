import 'package:client/api/models/monitoring_item.dart';
import 'package:client/api/monitoring_api.dart';
import 'package:client/shared/responsive_scaffold.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonitoringRoute extends StatelessWidget {
  static const routeName = '/monitoring';
  static const icon = Icons.show_chart;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(title: Text('Monitoring')),
      child: GraphList(),
    );
  }
}

class GraphList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MonitoringApi api = context.repository();
    return StreamBuilder(
      stream: this.getData(api),
      builder: (context, AsyncSnapshot<List<MonitoringItemModel>> state) {
        if (state.hasData) {
          return ListView(
            children: state.data.map((e) => Graph(e)).toList(),
          );
        }
        return Container();
      },
    );
  }

  Stream<List<MonitoringItemModel>> getData(MonitoringApi api) async* {
    while (true) {
      yield await api.getMonitoringData();
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

class Graph extends StatelessWidget {
  final MonitoringItemModel item;

  Graph(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(this.item.name),
        LineChart(
          LineChartData(titlesData: FlTitlesData(show: false), lineBarsData: [
          LineChartBarData(
              spots: this
                  .item
                  .history
                  .asMap()
                  .map((i, e) => MapEntry(i, FlSpot(i.toDouble(), e.value)))
                  .values
                  .toList(),
              isCurved: true,
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                  show: true, colors: [Colors.orangeAccent.withOpacity(0.3)]))
        ]), swapAnimationDuration: Duration())
      ],
    );
  }
}
