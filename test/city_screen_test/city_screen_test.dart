import 'package:bloc_test/bloc_test.dart';
import 'package:clima/screens/bloc/weather_bloc.dart';
import 'package:clima/screens/city_screen.dart';
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
          child: CityScreen(),
        ),
        navObserver: navigatorObserver);
  });

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  testWidgets('city_screen content is shown when WeatherInitial',
      (tester) async {
    whenListen(
      weatherBloc,
      Stream.fromIterable([WeatherInitial()]),
      initialState: WeatherInitial(),
    );

    await tester.pumpWidget(testingWidget);
    await tester.pump();

    final cityScreenMainContainer =
        find.byKey(Key('city_screen_main_container'));
    expect(cityScreenMainContainer, findsOneWidget);

    final cityScreenGoBackButton = find.byKey(Key('city_screen_goBack_button'));
    expect(cityScreenGoBackButton, findsOneWidget);

    final cityScreenTextField = find.byKey(Key('city_screen_textField'));
    expect(cityScreenTextField, findsOneWidget);

    final cityScreenSearchCityButton =
        find.byKey(Key('city_screen_searchCity_button'));
    expect(cityScreenSearchCityButton, findsOneWidget);
  });

  group('city_screen buttons', () {
    testWidgets('city_screen_goBack_button is pressed', (tester) async {
      whenListen(
        weatherBloc,
        Stream.fromIterable([WeatherInitial()]),
        initialState: WeatherInitial(),
      );

      await tester.pumpWidget(testWidget(
        BlocProvider<WeatherBloc>(
          create: (context) => weatherBloc,
          child: CityScreen(),
        ),
        navObserver: navigatorObserver,
      ));
      await tester.pumpAndSettle();

      final cityScreenGoBackButton =
          find.byKey(Key('city_screen_goBack_button'));
      expect(cityScreenGoBackButton, findsOneWidget);
      await tester.tap(cityScreenGoBackButton);
      await tester.pump();

      verify(() => navigatorObserver.didPop(captureAny<Route>(), any<Route>()))
          .called(1);

      await tester.pumpAndSettle();

      final cityScreenMainContainer =
          find.byKey(Key('city_screen_main_container'));
      expect(cityScreenMainContainer, findsNothing);
    });

    testWidgets('city_screen_searchCity_button is pressed', (tester) async {
      whenListen(
        weatherBloc,
        Stream.fromIterable([WeatherInitial()]),
        initialState: WeatherInitial(),
      );

      await tester.pumpWidget(testWidget(
        BlocProvider<WeatherBloc>(
          create: (context) => weatherBloc,
          child: CityScreen(),
        ),
        navObserver: navigatorObserver,
      ));
      await tester.pumpAndSettle();

      final cityScreenSearchCityButton =
          find.byKey(Key('city_screen_searchCity_button'));
      expect(cityScreenSearchCityButton, findsOneWidget);
      await tester.tap(cityScreenSearchCityButton);
      await tester.pumpAndSettle();

      verify(() => navigatorObserver.didPop(captureAny<Route>(), any<Route>()))
          .called(1);

      await tester.pumpAndSettle();

      final cityScreenMainContainer =
          find.byKey(Key('city_screen_main_container'));
      expect(cityScreenMainContainer, findsNothing);
    });

    testWidgets('city_screen_textField enterText', (tester) async {
      whenListen(
        weatherBloc,
        Stream.fromIterable([WeatherInitial()]),
        initialState: WeatherInitial(),
      );

      await tester.pumpWidget(testWidget(
        BlocProvider<WeatherBloc>(
          create: (context) => weatherBloc,
          child: CityScreen(),
        ),
        navObserver: navigatorObserver,
      ));
      await tester.pumpAndSettle();

      final cityScreenTextField = find.byKey(Key('city_screen_textField'));
      expect(cityScreenTextField, findsOneWidget);

      await tester.enterText(cityScreenTextField, 'text');
      await tester.pump();

      expect(find.text('text'), findsOneWidget);
    });
  });
}
