import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clima/models/weather.dart';
import 'package:clima/repositories/weather_repository/weather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({@required WeatherRepository weatherRepository})
      : assert(weatherRepository != null),
        _weatherRepository = weatherRepository,
        super(WeatherInitial());

  final WeatherRepository _weatherRepository;

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetLocalWeather) {
      yield* _localWeatherChangedToState();
    } else if (event is GetCityWeather) {
      yield* _cityWeatherChangedToState(event.cityName);
    }
  }

  Stream<WeatherState> _localWeatherChangedToState() async* {
    yield WeatherLoading();
    try {
      final weather = await _weatherRepository.getLocationWeather();
      yield WeatherLoaded(weatherModel: weather);
    } catch (e) {
      yield WeatherLoadingFail();
    }
  }

  Stream<WeatherState> _cityWeatherChangedToState(String cityName) async* {
    yield WeatherLoading();
    try {
      final cityWeather = await _weatherRepository.getCityWeather(cityName);
      yield WeatherLoaded(weatherModel: cityWeather);
    } catch (e) {
      yield WeatherLoadingFail();
    }
  }
}
