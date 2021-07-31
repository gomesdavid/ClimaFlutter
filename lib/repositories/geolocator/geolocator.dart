import 'package:geolocator/geolocator.dart';

class GeolocatorCustom extends GeolocatorPlatform {
  final GeolocatorPlatform _geolocatorPlatform;

  GeolocatorCustom({GeolocatorPlatform geolocatorPlatform})
      : _geolocatorPlatform = geolocatorPlatform ?? GeolocatorPlatform.instance;

  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration timeLimit,
  }) async {
    return await _geolocatorPlatform.getCurrentPosition(
      desiredAccuracy: desiredAccuracy,
      forceAndroidLocationManager: true,
    );
  }
}
