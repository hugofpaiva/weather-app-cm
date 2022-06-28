import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Weather.dart';

class ForecastWidget extends StatelessWidget {
  List<Weather> forecastList;
  ForecastWidget(this.forecastList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        Text("Next Days", style: TextStyle(fontSize: 24, letterSpacing: 2.0)),
        SizedBox(height: 10,),
        ListView.builder(
            itemCount: forecastList.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    flex:2,
                      child: Text(DateFormat('yyyy-MM-dd HH:mm').format(forecastList[index].date))),
                  Expanded(child: Image.network(
                      "http://openweathermap.org/img/wn/${forecastList[index].icon}.png")),
                  Expanded(child: Text("${forecastList[index].temperature.minTemp.toStringAsFixed(2)}ºC")),
                  Expanded(child: Text(
                    "${forecastList[index].temperature.maxTemp.toStringAsFixed(2)}ºC",
                    style: TextStyle(fontSize: 15),
                  )),
                ],
              );
            })
      ]),
    );
  }
}
