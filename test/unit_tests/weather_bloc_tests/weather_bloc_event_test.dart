import 'package:clima/screens/bloc/weather_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('props', () {
    test('GetLocalWeather', () {
      expect(GetLocalWeather().props, []);
    });

    test('GetCityWeather', () {
      expect(GetCityWeather('Tokyo').props, ['Tokyo']);
    });
  });
}
