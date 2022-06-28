import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_application/models/Forecast.dart';

import '../models/Weather.dart';


class OpenWeatherService {

  static const BASE_URL = "https://api.openweathermap.org/data/2.5";
  static const WEATHER_ENDPOINT = "weather";
  static const FORECAST_ENDPOINT = "forecast";
  static const API_KEY = "861456afeca108b7b8d895ff6a10d08f";

  Future<Weather?> getWeatherByLatLong(lat, lon) async {
    var url = Uri.parse("$BASE_URL/$WEATHER_ENDPOINT?lat=$lat&lon=$lon&units=metric&appid=$API_KEY");
    var response = await http.get(url);
    if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<String, dynamic>();
    return Weather.fromJson(parsed);
    }
    return null;
  }

  Future<Weather?> getWeatherByCity(cityName) async {
    var url = Uri.parse("$BASE_URL/$WEATHER_ENDPOINT?q=$cityName,PT&units=metric&appid=$API_KEY");
    var response = await http.get(url);
    if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<String, dynamic>();
    return Weather.fromJson(parsed);
    }
    return null;
  }

  Future<Forecast?> getForecastByLatLong(lat, lon) async {
    var url = Uri.parse("$BASE_URL/$FORECAST_ENDPOINT?lat=$lat&lon=$lon&units=metric&appid=$API_KEY");
    var response = await http.get(url);
    if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<String, dynamic>();
      return Forecast.fromJson(parsed);
    }
    return null;
  }

  Future<Forecast?> getForecastByCity(cityName) async {
    var url = Uri.parse("$BASE_URL/$FORECAST_ENDPOINT?q=$cityName,PT&units=metric&appid=$API_KEY");
    var response = await http.get(url);
    if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<String, dynamic>();
    return Forecast.fromJson(parsed);
    }
    return null;
  }
}