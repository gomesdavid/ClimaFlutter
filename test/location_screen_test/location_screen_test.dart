import 'package:bloc_test/bloc_test.dart';
import 'package:clima/models/weather.dart';
import 'package:clima/screens/bloc/weather_bloc.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test_helper/test-helper.dart';

class MockWeatherBloc extends Mock implements WeatherBloc {}

class FakeRoute<T> extends Fake implements Route<T> {}

void main() {
  Widget testingWidget;
  final weatherBloc = MockWeatherBloc();
  var navigatorObserver = MockNavigatorObserver();

  setUp(() {
    testingWidget = testWidget(
        BlocProvider<WeatherBloc>(
          create: (context) => weatherBloc,
          child: LocationScreen(),
        ),
        navObserver: navigatorObserver);
  });

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  testWidgets('location_screen content is shown when WeatherInitial',
      (tester) async {
    whenListen(
      weatherBloc,
      Stream.fromIterable([WeatherInitial()]),
      initialState: WeatherInitial(),
    );

    await tester.pumpWidget(testingWidget);
    await tester.pump();

    final locationScreenMainContainer =
        find.byKey(Key('location_screen_main_container'));
    expect(locationScreenMainContainer, findsOneWidget);

    final locationScreenspinKitDoubleBounce =
        find.byKey(Key('location_screen_spinKitDoubleBounce'));
    expect(locationScreenspinKitDoubleBounce, findsOneWidget);

    final locationScreenRefreshButton =
        find.byKey(Key('location_screen_refresh_button'));
    expect(locationScreenRefreshButton, findsNothing);

    final locationScreenErrorText =
        find.byKey(Key('location_screen_error_text'));
    expect(locationScreenErrorText, findsNothing);

    final locationScreenSearchCity =
        find.byKey(Key('location_screen_search_city_button'));
    expect(locationScreenSearchCity, findsNothing);

    final locationScreenTemperatureText =
        find.byKey(Key('location_screen_temperature_text'));
    expect(locationScreenTemperatureText, findsNothing);

    final locationScreenWeatherIconText =
        find.byKey(Key('location_screen_weatherIcon_text'));
    expect(locationScreenWeatherIconText, findsNothing);

    final locationScreenTemperatureMessageText =
        find.byKey(Key('location_screen_temperatureMessage_text'));
    expect(locationScreenTemperatureMessageText, findsNothing);
  });

  testWidgets('location_screen content is shown when WeatherLocalLoaded',
      (tester) async {
    whenListen(
      weatherBloc,
      Stream.fromIterable(
        [
          WeatherLoaded(
            weatherModel: WeatherModel(
              cityName: 'Lisbon',
              condition: 350,
              temperature: 25,
            ),
          ),
        ],
      ),
      initialState: WeatherInitial(),
    );

    await tester.pumpWidget(testingWidget);
    await tester.pumpAndSettle();

    final locationScreenMainContainer =
        find.byKey(Key('location_screen_main_container'));
    expect(locationScreenMainContainer, findsOneWidget);

    final locationScreenErrorText =
        find.byKey(Key('location_screen_error_text'));
    expect(locationScreenErrorText, findsNothing);

    final locationScreenspinKitDoubleBounce =
        find.byKey(Key('location_screen_spinKitDoubleBounce'));
    expect(locationScreenspinKitDoubleBounce, findsNothing);

    final locationScreenRefreshButton =
        find.byKey(Key('location_screen_refresh_button'));
    expect(locationScreenRefreshButton, findsOneWidget);

    final locationScreenSearchCity =
        find.byKey(Key('location_screen_search_city_button'));
    expect(locationScreenSearchCity, findsOneWidget);

    final locationScreenTemperatureText =
        find.byKey(Key('location_screen_temperature_text'));
    expect(locationScreenTemperatureText, findsOneWidget);

    final locationScreenWeatherIconText =
        find.byKey(Key('location_screen_weatherIcon_text'));
    expect(locationScreenWeatherIconText, findsOneWidget);

    final locationScreenTemperatureMessageText =
        find.byKey(Key('location_screen_temperatureMessage_text'));
    expect(locationScreenTemperatureMessageText, findsOneWidget);
  });

  testWidgets('location_screen content is shown when WeatherLoadingFail',
      (tester) async {
    whenListen(
      weatherBloc,
      Stream.fromIterable([WeatherLoadingFail()]),
      initialState: WeatherInitial(),
    );

    await tester.pumpWidget(testingWidget);
    await tester.pumpAndSettle();

    final locationScreenMainContainer =
        find.byKey(Key('location_screen_main_container'));
    expect(locationScreenMainContainer, findsOneWidget);

    final locationScreenErrorText =
        find.byKey(Key('location_screen_error_text'));
    expect(locationScreenErrorText, findsOneWidget);

    final locationScreenspinKitDoubleBounce =
        find.byKey(Key('location_screen_spinKitDoubleBounce'));
    expect(locationScreenspinKitDoubleBounce, findsNothing);

    final locationScreenRefreshButton =
        find.byKey(Key('location_screen_refresh_button'));
    expect(locationScreenRefreshButton, findsNothing);

    final locationScreenSearchCity =
        find.byKey(Key('location_screen_search_city_button'));
    expect(locationScreenSearchCity, findsNothing);

    final locationScreenTemperatureText =
        find.byKey(Key('location_screen_temperature_text'));
    expect(locationScreenTemperatureText, findsNothing);

    final locationScreenWeatherIconText =
        find.byKey(Key('location_screen_weatherIcon_text'));
    expect(locationScreenWeatherIconText, findsNothing);

    final locationScreenTemperatureMessageText =
        find.byKey(Key('location_screen_temperatureMessage_text'));
    expect(locationScreenTemperatureMessageText, findsNothing);
  });

  testWidgets('location_screen_search_city_button is pressed ', (tester) async {
    whenListen(
      weatherBloc,
      Stream.fromIterable([
        WeatherLoaded(
          weatherModel: WeatherModel(
            cityName: 'Lisbon',
            condition: 350,
            temperature: 25,
          ),
        ),
      ]),
      initialState: WeatherInitial(),
    );

    final newMockNavigatorObserver = MockNavigatorObserver();

    await tester.pumpWidget(testWidget(
      BlocProvider<WeatherBloc>(
        create: (context) => weatherBloc,
        child: LocationScreen(),
      ),
      navObserver: newMockNavigatorObserver,
    ));

    await tester.pumpAndSettle();

    final locationScreenSearchCity =
        find.byKey(Key('location_screen_search_city_button'));
    expect(locationScreenSearchCity, findsOneWidget);

    await tester.tap(locationScreenSearchCity);
    verify(() =>
        newMockNavigatorObserver.didPush(captureAny<Route>(), any<Route>()));

    await tester.pumpAndSettle();

    final cityScreen = find.byKey(Key('city_screen'));
    expect(cityScreen, findsOneWidget);
  });

  testWidgets('refresh button tap adds [GetLocalWeather()] event to bloc',
      (tester) async {
    whenListen(
      weatherBloc,
      Stream.fromIterable(
        [
          WeatherLoaded(
            weatherModel: WeatherModel(
              cityName: 'Lisbon',
              condition: 350,
              temperature: 25,
            ),
          ),
        ],
      ),
      initialState: WeatherInitial(),
    );
    await tester.pumpWidget(testingWidget);
    await tester.pumpAndSettle();

    final locationScreenRefreshButton =
        find.byKey(Key('location_screen_refresh_button'));
    expect(locationScreenRefreshButton, findsOneWidget);

    await tester.tap(locationScreenRefreshButton);
    await tester.pump();

    verify(() => weatherBloc.add(GetLocalWeather()));
  });

  testWidgets(
      'search city button tap adds [GetCityWeather(typedCityName)] event to bloc',
      (tester) async {
    whenListen(
      weatherBloc,
      Stream.fromIterable(
        [
          WeatherLoaded(
            weatherModel: WeatherModel(
              cityName: 'Lisbon',
              condition: 350,
              temperature: 25,
            ),
          ),
        ],
      ),
      initialState: WeatherInitial(),
    );

    final newMockNavigatorObserver = MockNavigatorObserver();

    await tester.pumpWidget(testWidget(
      BlocProvider<WeatherBloc>(
        create: (context) => weatherBloc,
        child: LocationScreen(),
      ),
      navObserver: newMockNavigatorObserver,
    ));
    await tester.pumpAndSettle();

    final locationScreenSearchCity =
        find.byKey(Key('location_screen_search_city_button'));
    expect(locationScreenSearchCity, findsOneWidget);

    await tester.tap(locationScreenSearchCity);
    await tester.pumpAndSettle();

    verify(() =>
            newMockNavigatorObserver.didPush(captureAny<Route>(), any<Route>()))
        .called(2);

    final cityScreenTextField = find.byKey(Key('city_screen_textField'));
    expect(cityScreenTextField, findsOneWidget);
    await tester.enterText(cityScreenTextField, 'Tokyo');
    await tester.pump();
    expect(find.text('Tokyo'), findsOneWidget);

    final cityScreenSearchCityButton =
        find.byKey(Key('city_screen_searchCity_button'));
    expect(cityScreenSearchCityButton, findsOneWidget);
    await tester.tap(cityScreenSearchCityButton);

    verify(() =>
            newMockNavigatorObserver.didPop(captureAny<Route>(), any<Route>()))
        .called(1);

    verify(() => weatherBloc.add(GetCityWeather('Tokyo')));
  });
}
