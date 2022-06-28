import 'package:weather_application/models/OtherInformation.dart';
import 'package:weather_application/models/Temperature.dart';
import 'package:weather_application/models/Wind.dart';

class Weather {
  String? city;
  double? latitude;
  double? longitude;
  String weather;
  String icon;
  int visibility;
  Temperature temperature;
  Wind? wind;
  OtherInformation otherInformation;
  DateTime date;

  Weather(
      {this.city,
      this.latitude,
      this.longitude,
      required this.weather,
      required this.temperature,
      this.wind,
      required this.visibility,
      required this.otherInformation,
      required this.icon,
      required this.date});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        city: json['name'],
        latitude: (json['<coord>']?.isNotEmpty ?? false)
            ? json['coord']['lat']
            : null,
        longitude: (json['<coord>']?.isNotEmpty ?? false)
            ? json['coord']['lon']
            : null,
        weather: json['weather'][0]['main'] as String,
        temperature: Temperature(
            currentTemp: json['main']['temp'].toDouble(),
            minTemp: json['main']['temp_min'].toDouble(),
            maxTemp: json['main']['temp_max'].toDouble(),
            pressure: json['main']['pressure'] as int,
            humidity: json['main']['humidity'] as int,
            sensationTemp: json['main']['feels_like'].toDouble()),
        visibility: json['visibility'] as int,
        wind: (json['<wind>']?.isNotEmpty ?? false)
            ? Wind(json['wind']['speed'] as double, json['wind']['deg'] as int,
                json['wind']['gust'] as double)
            : null,
        otherInformation: OtherInformation(
            DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] ?? 0),
            DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] ?? 0)),
        icon: json['weather'][0]['icon'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000));
  }

  Map<String, dynamic> toJson() {
    return {
      'name': city,
      'coord': latitude == null || longitude == null
          ? null
          : {'lat': latitude, 'lon': longitude},
      'weather': [
        {'main': weather, 'icon': icon}
      ],
      'main': {
        'temp': temperature.currentTemp,
        'temp_min': temperature.minTemp,
        'temp_max': temperature.maxTemp,
        'pressure': temperature.pressure,
        'humidity': temperature.humidity,
        'feels_like': temperature.sensationTemp
      },
      'visibility': visibility,
      'wind': {'speed': wind?.speed, 'deg': wind?.deg, 'gust': wind?.gust},
      'sys': {
        'sunrise': otherInformation.sunriseTimestamp.millisecondsSinceEpoch,
        'sunset': otherInformation.sunsetTimestamp.millisecondsSinceEpoch
      },
      'dt': date.millisecondsSinceEpoch~/1000
    };
  }
}
