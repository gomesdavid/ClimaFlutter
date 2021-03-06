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
      return '๐ฉ';
    } else if (condition < 400) {
      return '๐ง';
    } else if (condition < 600) {
      return 'โ๏ธ';
    } else if (condition < 700) {
      return 'โ๏ธ';
    } else if (condition < 800) {
      return '๐ซ';
    } else if (condition == 800) {
      return 'โ๏ธ';
    } else if (condition <= 804) {
      return 'โ๏ธ';
    } else {
      return '๐คทโ';
    }
  }

  String _getTemperatureMessage(int temp) {
    if (temp > 25) {
      return 'It\'s ๐ฆ time';
    } else if (temp > 20) {
      return 'Time for shorts and ๐';
    } else if (temp < 10) {
      return 'You\'ll need ๐งฃ and ๐งค';
    } else {
      return 'Bring a ๐งฅ just in case';
    }
  }
}
