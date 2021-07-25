part of 'weather_bloc.dart';

@immutable
abstract class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weatherModel;

  WeatherLoaded({this.weatherModel});

  @override
  List<Object> get props => [weatherModel];
}

class WeatherLoading extends WeatherState {}

class WeatherLoadingFail extends WeatherState {}
