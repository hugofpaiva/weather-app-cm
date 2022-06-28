import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/Weather.dart';

class LineChartWidget extends StatelessWidget {
  List<Weather> forecastList;
  LineChartWidget({required this.forecastList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 300,
        child: LineChart(
     LineChartData(
       maxY: (forecastList.map((weather) => weather.temperature.currentTemp).toList().reduce(max)+1).roundToDouble(),
       minY: (forecastList.map((weather) => weather.temperature.currentTemp).toList().reduce(min)-1).roundToDouble(),
       borderData: FlBorderData(show: false),
         lineTouchData: LineTouchData(
           touchTooltipData: LineTouchTooltipData(
             tooltipBgColor: Colors.white,
           )
         ),
         titlesData: FlTitlesData(
           bottomTitles: AxisTitles(
               axisNameWidget: const Text("Time"),
               sideTitles: SideTitles(showTitles: true, interval: 3*3600000, getTitlesWidget: (value, meta) => Text("${DateTime.fromMillisecondsSinceEpoch(value.toInt()).hour}h"))),
           leftTitles: AxisTitles(
               axisNameWidget: const Text("Temperature (ºC)"),
               sideTitles:SideTitles(showTitles: true, reservedSize: 40)),
           rightTitles: AxisTitles(sideTitles:SideTitles(showTitles: false)),
           topTitles: AxisTitles(sideTitles:SideTitles(showTitles: false)),
         ),
       lineBarsData: [
         LineChartBarData(
         color: Colors.deepPurple,
             dotData: FlDotData(
               show: false,
             ),
         spots: forecastList.map((weather) => FlSpot(weather.date.millisecondsSinceEpoch.toDouble(), weather.temperature.currentTemp)).toList()
       )],
     )
    ));
  }
}
