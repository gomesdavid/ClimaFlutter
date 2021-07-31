import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final int temperature;
  final String cityName;
  final int condition;

  WeatherModel({
    this.temperature,
    this.cityName,
    this.condition,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> map) {
    double temp = map['main']['temp'];
    return WeatherModel(
      temperature: temp.toInt(),
      cityName: map['name'],
      condition: map['weather'][0]['id'],
    );
  }

  @override
  List<Object> get props => [temperature, cityName, condition];

  String get weatherIcon => _getWeatherIcon(condition);

  String get temperatureMessage => _getTemperatureMessage(temperature);

  String _getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String _getTemperatureMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
