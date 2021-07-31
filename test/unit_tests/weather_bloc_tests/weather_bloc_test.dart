import 'package:bloc_test/bloc_test.dart';
import 'package:clima/models/weather.dart';
import 'package:clima/repositories/weather_repository/weather_repository.dart';
import 'package:clima/screens/bloc/weather_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  WeatherBloc bloc;
  final mockWeatherRepository = MockWeatherRepository();
  final _initialState = WeatherInitial();

  setUp(() {
    bloc = WeatherBloc(
      weatherRepository: mockWeatherRepository,
    );
  });

  test('null weatherRepository throws assertion error exception', () {
    expect(
      () => WeatherBloc(weatherRepository: null),
      throwsAssertionError,
    );
  });

  group('states', () {
    test('initial state is correct', () async {
      expect(bloc.state, _initialState);
    });

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherLoaded] when WeatherLoaded in _localWeatherChangedToState is added success.',
      build: () {
        when(() => mockWeatherRepository.getLocationWeather()).thenAnswer(
          (_) => Future.value(
            WeatherModel(
              cityName: 'Lisbon',
              condition: 350,
              temperature: 25,
            ),
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(GetLocalWeather()),
      seed: () => _initialState,
      expect: () => [
        WeatherLoading(),
        WeatherLoaded(
          weatherModel: WeatherModel(
            cityName: 'Lisbon',
            condition: 350,
            temperature: 25,
          ),
        ),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherLoaded] when WeatherLoaded in _localWeatherChangedToState is added fail.',
      build: () {
        when(() => mockWeatherRepository.getLocationWeather())
            .thenThrow(Exception('error'));
        return bloc;
      },
      act: (bloc) => bloc.add(GetLocalWeather()),
      seed: () => _initialState,
      expect: () => [
        WeatherLoading(),
        WeatherLoadingFail(),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherLoaded] when WeatherLoaded in _cityWeatherChangedToState is added success.',
      build: () {
        when(() => mockWeatherRepository.getCityWeather('Lisbon')).thenAnswer(
          (_) => Future.value(
            WeatherModel(
              cityName: 'Lisbon',
              condition: 350,
              temperature: 25,
            ),
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(GetCityWeather('Lisbon')),
      seed: () => _initialState,
      expect: () => [
        WeatherLoading(),
        WeatherLoaded(
          weatherModel: WeatherModel(
            cityName: 'Lisbon',
            condition: 350,
            temperature: 25,
          ),
        ),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherLoaded] when WeatherLoaded in _cityWeatherChangedToState is added fail.',
      build: () {
        when(() => mockWeatherRepository.getCityWeather('Lisbon'))
            .thenThrow(Exception('error'));
        return bloc;
      },
      act: (bloc) => bloc.add(GetCityWeather('Lisbon')),
      seed: () => _initialState,
      expect: () => [
        WeatherLoading(),
        WeatherLoadingFail(),
      ],
    );
  });
}
