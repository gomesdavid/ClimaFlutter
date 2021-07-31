import 'package:geolocator/geolocator.dart';

abstract class WeatherEndpoints {
  static final _apiKey = '39583d762677b8fba1fe49d6bbde9654';
  static final _openWeatherMapURL =
      'http://api.openweathermap.org/data/2.5/weather';

  static String getCityWeather(String cityName, {String apiKey}) =>
      '$_openWeatherMapURL?q=$cityName&appid=$_apiKey&units=metric';

  static String getLocationWeather(Position location) =>
      '$_openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$_apiKey&units=metric';
}
