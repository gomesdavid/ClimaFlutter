import 'package:clima/screens/bloc/weather_bloc.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => WeatherBloc()
          ..add(
            GetLocalWeather(),
          ),
        child: LocationScreen(),
      ),
    );
  }
}
