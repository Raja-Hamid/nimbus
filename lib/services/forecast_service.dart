import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:nimbus/models/forecast.dart';

class ForecastService {
  static Future<Position> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  static Future<List<Forecast>> fetchForecast() async {
    final position = await _getCurrentPosition();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'latitude': position.latitude,
        'longitude': position.longitude,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['forecast'];
      return data.map((day) => Forecast.fromJson(day)).toList();
    } else {
      throw Exception('Failed to fetch forecast');
    }
  }
}
