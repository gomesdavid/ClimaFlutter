import 'package:clima/screens/bloc/weather_bloc.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/models/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: Key('location_screen_main_container'),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoaded) {
                return _WeatherInfoPage(
                  weatherModel: (state).weatherModel,
                );
              } else if (state is WeatherLoadingFail) {
                return Container(
                  child: Center(
                    child: Text(
                      'Error',
                      key: Key('location_screen_error_text'),
                    ),
                  ),
                );
              } else {
                return SpinKitDoubleBounce(
                  key: Key('location_screen_spinKitDoubleBounce'),
                  color: Colors.white,
                  size: 100.0,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _WeatherInfoPage extends StatelessWidget {
  const _WeatherInfoPage({
    Key key,
    @required this.weatherModel,
  }) : super(key: key);

  final WeatherModel weatherModel;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WeatherBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              key: Key('location_screen_refresh_button'),
              onPressed: () => bloc.add(GetLocalWeather()),
              child: Icon(
                Icons.near_me,
                size: 50.0,
              ),
            ),
            TextButton(
              key: Key('location_screen_search_city_button'),
              onPressed: () async {
                var typedCityName = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return CityScreen(
                    key: Key('city_screen'),
                  );
                }));
                bloc.add(GetCityWeather(typedCityName));
              },
              child: Icon(
                Icons.location_city,
                size: 50.0,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Row(
            children: <Widget>[
              Text(
                '${weatherModel.temperature}º',
                key: Key('location_screen_temperature_text'),
                style: kTempTextStyle,
              ),
              Text(
                weatherModel.weatherIcon,
                key: Key('location_screen_weatherIcon_text'),
                style: kConditionTextStyle,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Text(
            "${weatherModel.temperatureMessage} in ${weatherModel.cityName}!",
            key: Key('location_screen_temperatureMessage_text'),
            textAlign: TextAlign.right,
            style: kMessageTextStyle,
          ),
        ),
      ],
    );
  }
}
