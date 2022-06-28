import 'Weather.dart';

class Forecast {
  String city;
  List<Weather> forecast;

  Forecast({required this.city, required this.forecast});

  factory Forecast.fromJson(Map<String, dynamic> json){
    return Forecast(
        city: json['city']['name'],
        forecast: json['list'].toList().map<Weather>((item) => Weather.fromJson(item)).toList());
  }
}