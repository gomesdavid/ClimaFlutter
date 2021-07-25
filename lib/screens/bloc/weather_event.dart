part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetLocalWeather extends WeatherEvent {}

class GetCityWeather extends WeatherEvent {
  final String cityName;

  GetCityWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}
