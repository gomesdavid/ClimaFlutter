import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

Widget testWidget(Widget testingWidget, {NavigatorObserver navObserver}) {
  return MaterialApp(
    home: Scaffold(
      body: testingWidget,
    ),
    navigatorObservers: [
      navObserver ?? MockNavigatorObserver(),
    ],
  );
}
