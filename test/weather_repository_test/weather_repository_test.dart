import 'package:clima/models/weather.dart';
import 'package:clima/repositories/geolocator/geolocator.dart';
import 'package:clima/repositories/weather_repository/weather_repository.dart';
import 'package:clima/services/networking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

class MockGeolocatorCustom extends Mock implements GeolocatorCustom {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockNetworkHelper extends Mock implements NetworkHelper {}

void main() {
  final mockGeolocatorCustom = MockGeolocatorCustom();

  final mockNetworkHelper = MockNetworkHelper();
  WeatherRepository weatherRepository;

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

  final map = {
    'main': {'temp': 3.0},
    'name': 'Lisbon',
    'weather': [
      {'id': 300}
    ]
  };

  setUp(() {
    weatherRepository = WeatherRepository(
      geolocatorCustom: mockGeolocatorCustom,
      networkHelper: mockNetworkHelper,
    );
  });

  test('getLocationWeather success', () async {
    when(() => mockGeolocatorCustom.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low))
        .thenAnswer((_) => Future.value(position));
    when(() => mockNetworkHelper.getLocationWeatherData(position))
        .thenAnswer((_) => Future.value(map));
    final getLocationWeather = await weatherRepository.getLocationWeather();
    expect(
        getLocationWeather,
        WeatherModel(
          cityName: 'Lisbon',
          condition: 300,
          temperature: 3,
        ));
    try {} catch (e) {
      print(e);
    }
  });

  test('getLocationWeather fail', () async {
    when(() => mockGeolocatorCustom.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low)).thenThrow(Exception('fail'));
    try {
      await weatherRepository.getLocationWeather();
      fail('this should fail');
    } catch (e) {
      expect(e.toString(), Exception('fail').toString());
      // expect(actual, matcher)
    }
  });

  test('getCityWeather success', () async {
    when(() => mockNetworkHelper.getCityWeatherData('Lisbon'))
        .thenAnswer((_) => Future.value(map));
    final getCityWeather = await weatherRepository.getCityWeather('Lisbon');
    expect(
      getCityWeather,
      WeatherModel(
        cityName: 'Lisbon',
        condition: 300,
        temperature: 3,
      ),
    );
    try {} catch (e) {
      print(e);
    }
  });

  test('getCityWeather fail', () async {
    when(() => mockNetworkHelper.getCityWeatherData('Lisbon'))
        .thenThrow(Exception('fail'));
    try {
      await weatherRepository.getCityWeather('Lisbon');
      fail('this should fail');
    } catch (e) {
      expect(e.toString(), Exception('fail').toString());
      // expect(actual, matcher)
    }
  });
}
