import 'package:clima/repositories/weather_repository/weather_endpoints.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  final _apiKey = '39583d762677b8fba1fe49d6bbde9654';
  final _openWeatherMapURL = 'http://api.openweathermap.org/data/2.5/weather';
  final _metrics = 'metric';

  test('endpoint getCityWeather', () {
    final expectedResult =
        '$_openWeatherMapURL?q=Tokyo&appid=$_apiKey&units=$_metrics';
    expect(
      WeatherEndpoints.getCityWeather('Tokyo'),
      expectedResult,
    );
  });

  test('endpoint getLocationWeather', () {
    final position = Position(
      longitude: 20.0,
      latitude: 20.0,
      accuracy: 10,
      altitude: 10,
      heading: 10,
      speed: 10,
      speedAccuracy: 10,
      timestamp: null,
    );
    final expectedResult =
        '$_openWeatherMapURL?lat=20.0&lon=20.0&appid=$_apiKey&units=$_metrics';
    expect(
      WeatherEndpoints.getLocationWeather(position),
      expectedResult,
    );
  });
}
