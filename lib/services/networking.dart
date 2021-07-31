import 'package:clima/repositories/weather_repository/weather_endpoints.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'dart:convert';

class NetworkHelper {
  NetworkHelper({Client client}) : http = client ?? Client();

  final Client http;

  Future _getData(String url) async {
    Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;

      var decodedData = jsonDecode(data);

      return decodedData;
    }
  }

  Future getCityWeatherData(String cityName) async {
    return await _getData(WeatherEndpoints.getCityWeather(cityName));
  }

  Future getLocationWeatherData(Position location) async {
    return await _getData(WeatherEndpoints.getLocationWeather(location));
  }
}
