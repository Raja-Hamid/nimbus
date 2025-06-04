import 'package:geolocator/geolocator.dart';

class LocationService {
  static Position? _cachedPosition;

  static Future<Position> getCurrentLocation() async {
    if (_cachedPosition != null) return _cachedPosition!;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }
    }
    _cachedPosition = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return _cachedPosition!;
  }
}
