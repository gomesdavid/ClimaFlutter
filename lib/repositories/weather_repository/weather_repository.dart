import 'package:clima/models/weather.dart';
import 'package:clima/repositories/location_repository/location_repository.dart';
import 'package:clima/repositories/weather_repository/weather_endpoints.dart';
import 'package:clima/services/networking.dart';

abstract class WeatherApi {
  Future<dynamic> getCityWeather(String cityName);

  Future<dynamic> getLocationWeather();
}

class WeatherRepository extends WeatherApi {
  WeatherRepository() : _locationRepository = LocationRepository();

  final LocationRepository _locationRepository;

  @override
  Future<WeatherModel> getCityWeather(String cityName) async {
    final weatherData =
        await NetworkHelper(WeatherEndpoints.getCityWeather(cityName))
            .getData();
    return WeatherModel.fromJson(weatherData);
  }

  @override
  Future<WeatherModel> getLocationWeather() async {
    final location = await _locationRepository.getCurrentLocation();

    var weatherData =
        await NetworkHelper(WeatherEndpoints.getLocationWeather(location))
            .getData();

    return WeatherModel.fromJson(weatherData);
  }
}
