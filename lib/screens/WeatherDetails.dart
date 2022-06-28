import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_application/models/Forecast.dart';
import 'package:weather_application/models/Weather.dart';
import 'package:weather_application/services/OpenWeatherService.dart';
import 'package:weather_application/widgets/ForecastWidget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:weather_application/widgets/LineChartWidget.dart';

class WeatherDetails extends StatefulWidget {
  Weather weather;
  WeatherDetails(this.weather, {Key? key}) : super(key: key);

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  Forecast? forecastWeather;

  Future<void> getForecastData() async {
    Forecast? forecast =
        await OpenWeatherService().getForecastByCity(widget.weather.city);

    if (forecast != null) {
      setState(() => forecastWeather = forecast);
    }
  }

  @override
  initState() {
    getForecastData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3CCE3),
      body: SafeArea(
        child: Center(
            child: forecastWeather != null
                ? SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Column(
                      children: [
                        Image.network(
                            "http://openweathermap.org/img/wn/${widget.weather.icon}@4x.png"),
                        Text(
                          widget.weather.city ?? "",
                          style:
                              const TextStyle(fontSize: 32, letterSpacing: 2.0),
                        ),
                        Text(widget.weather.weather),
                        Text(
                            "${widget.weather.temperature.currentTemp.toStringAsFixed(1)}ºC",
                            style: const TextStyle(
                                fontSize: 64, letterSpacing: 2.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Min: ${widget.weather.temperature.minTemp}ºC | "),
                            Text(
                                "Max: ${widget.weather.temperature.maxTemp}ºC"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Next Hours",
                                      style: TextStyle(
                                          fontSize: 24, letterSpacing: 2.0)),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(LineIcons.water),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              "Humidity: ${widget.weather.temperature.humidity}%"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(LineIcons.eye),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              "Visibility: ${widget.weather.visibility} m"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  widget.weather.wind != null
                                      ? Row(
                                          children: [
                                            const Icon(LineIcons.wind),
                                            Text(
                                                "${widget.weather.wind?.speed} m/s")
                                          ],
                                        )
                                      : Container(),
                                  const SizedBox(height: 10),
                                  LineChartWidget(
                                      forecastList: forecastWeather!.forecast
                                          .where((element) => element.date
                                              .isBefore(DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day,
                                                  DateTime.now().hour + 24)))
                                          .toList()),
                                ],
                              ),
                            )),
                        ForecastWidget(forecastWeather!.forecast
                            .where((element) => element.date.isAfter(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + 1)))
                            .toList()),
                      ],
                    ),
                  )
                : const SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 50.0,
                  )),
      ),
    );
  }
}
