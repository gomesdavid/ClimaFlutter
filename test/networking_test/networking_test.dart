import 'dart:convert';

import 'package:clima/repositories/weather_repository/weather_endpoints.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:clima/services/networking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements Client {}

void main() {
  final mockClient = MockClient();
  NetworkHelper networkHelper;

  final json = jsonEncode("{response:1, fake:['0', '1']}");

  final jsonDecoded = jsonDecode(json);

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

  setUp(() {
    networkHelper = NetworkHelper(client: mockClient);
  });

  test('getCityWeatherData success', () async {
    when(() => mockClient
            .get(Uri.parse(WeatherEndpoints.getCityWeather('Lisbon'))))
        .thenAnswer((_) => Future.value(Response(json, 200)));
    final weatherData = await networkHelper.getCityWeatherData('Lisbon');
    expect(weatherData, jsonDecoded);
  });

  test('getLocationWeatherData success', () async {
    when(() => mockClient
            .get(Uri.parse(WeatherEndpoints.getLocationWeather(position))))
        .thenAnswer((_) => Future.value(Response(json, 200)));
    final weatherData = await networkHelper.getLocationWeatherData(position);
    expect(weatherData, jsonDecoded);
  });
}
