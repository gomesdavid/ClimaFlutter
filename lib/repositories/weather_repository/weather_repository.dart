import 'package:clima/models/weather.dart';
import 'package:clima/repositories/geolocator/geolocator.dart';
import 'package:clima/services/networking.dart';
import 'package:geolocator/geolocator.dart';

abstract class WeatherApi {
  Future<dynamic> getCityWeather(String cityName);

  Future<dynamic> getLocationWeather();
}

class WeatherRepository extends WeatherApi {
  WeatherRepository(
      {GeolocatorCustom geolocatorCustom, NetworkHelper networkHelper})
      : _geolocatorCustom = geolocatorCustom ?? GeolocatorCustom(),
        _networkHelper = networkHelper ?? NetworkHelper();

  final GeolocatorCustom _geolocatorCustom;
  final NetworkHelper _networkHelper;

  @override
  Future<WeatherModel> getCityWeather(String cityName) async {
    final weatherData = await _networkHelper.getCityWeatherData(cityName);
    return WeatherModel.fromJson(weatherData);
  }

  @override
  Future<WeatherModel> getLocationWeather() async {
    final location = await _geolocatorCustom.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    var weatherData = await _networkHelper.getLocationWeatherData(location);

    return WeatherModel.fromJson(weatherData);
  }
}
