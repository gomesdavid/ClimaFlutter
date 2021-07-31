import 'package:clima/repositories/geolocator/geolocator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

void main() {
  final mockGeolocatorPlatform = MockGeolocatorPlatform();
  GeolocatorCustom geolocatorCustom;

  setUp(() {
    geolocatorCustom = GeolocatorCustom(
      geolocatorPlatform: mockGeolocatorPlatform,
    );
  });

  test('getCurrentPosition success', () async {
    final position = Position(
      longitude: 20.0,
      latitude: 20.0,
      accuracy: 10,
      altitude: 10,
      heading: 10,
      speed: 10,
      speedAccuracy: 10,
      timestamp: null,
    );
    when(() => mockGeolocatorPlatform.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          forceAndroidLocationManager: true,
        )).thenAnswer((_) => Future.value(position));
    final getCurrentPosition = await geolocatorCustom.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    expect(
      getCurrentPosition,
      position,
    );
    try {} catch (e) {
      print(e);
    }
  });

  test('getCurrentPosition fail', () async {
    when(() => mockGeolocatorPlatform.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          forceAndroidLocationManager: true,
        )).thenThrow(Exception('fail'));
    try {
      await geolocatorCustom.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true,
      );
      fail('this should fail');
    } catch (e) {
      expect(e.toString(), Exception('fail').toString());
      // expect(actual, matcher)
    }
  });
}
