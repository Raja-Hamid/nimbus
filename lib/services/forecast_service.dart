import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:nimbus/models/forecast.dart';

class ForecastService {
  static Future<List<Forecast>> fetchForecast(Position position) async {
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
