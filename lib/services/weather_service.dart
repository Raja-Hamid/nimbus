import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:nimbus/constants/keys.dart';
import 'package:nimbus/models/weather.dart';

class WeatherService {
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(Position position) async {
    return await _getWeatherByCity(position);
  }

  Future<String> _getCityFromLocation(Position position) async {
    final List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final city =
        placeMarks.first.locality ??
        placeMarks.first.administrativeArea ??
        'London';
    return city;
  }

  Future<Weather> _getWeatherByCity(Position position) async {
    String city = await _getCityFromLocation(position);
    final Uri uri = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather for $city');
    }
  }

  String getWeatherCondition(Weather weather) {
    final String condition = weather.condition.toLowerCase();
    final isNight =
        weather.lastUpdated.isBefore(weather.sunrise) ||
        weather.lastUpdated.isAfter(weather.sunset);

    String prefix = isNight ? 'night' : 'day';

    if (condition.contains('clear sky')) {
      return 'assets/lotties/${prefix}_clear.json';
    } else if (condition.toLowerCase().contains('light rain') ||
        condition.toLowerCase().contains('moderate rain') ||
        condition.toLowerCase().contains('heavy intensity rain') ||
        condition.toLowerCase().contains('very heavy rain') ||
        condition.toLowerCase().contains('extreme rain') ||
        condition.toLowerCase().contains('freezing rain') ||
        condition.toLowerCase().contains('light intensity shower rain') ||
        condition.toLowerCase().contains('shower rain') ||
        condition.toLowerCase().contains('heavy intensity shower rain') ||
        condition.toLowerCase().contains('ragged shower rain')) {
      return 'assets/lotties/${prefix}_rain.json';
    } else if (condition.toLowerCase().contains('light intensity drizzle') ||
        condition.toLowerCase().contains('drizzle') ||
        condition.toLowerCase().contains('heavy intensity drizzle') ||
        condition.toLowerCase().contains('light intensity drizzle rain') ||
        condition.toLowerCase().contains('drizzle rain') ||
        condition.toLowerCase().contains('heavy intensity drizzle rain') ||
        condition.toLowerCase().contains('shower rain and drizzle') ||
        condition.toLowerCase().contains('heavy shower rain and drizzle') ||
        condition.toLowerCase().contains('heavy shower rain and drizzle')) {
      return 'assets/lotties/${prefix}_drizzle.json';
    } else if (condition.toLowerCase().contains(
          'thunderstorm with light rain',
        ) ||
        condition.toLowerCase().contains('thunderstorm with rain') ||
        condition.toLowerCase().contains('thunderstorm with heavy rain') ||
        condition.toLowerCase().contains('light thunderstorm') ||
        condition.toLowerCase().contains('thunderstorm') ||
        condition.toLowerCase().contains('heavy thunderstorm') ||
        condition.toLowerCase().contains('ragged thunderstorm') ||
        condition.toLowerCase().contains('thunderstorm with light drizzle') ||
        condition.toLowerCase().contains('thunderstorm with drizzle') ||
        condition.toLowerCase().contains('thunderstorm with heavy drizzle')) {
      return 'assets/lotties/thunderstorm.json';
    } else if (condition.toLowerCase().contains('light snow') ||
        condition.toLowerCase().contains('snow') ||
        condition.toLowerCase().contains('heavy snow') ||
        condition.toLowerCase().contains('sleet') ||
        condition.toLowerCase().contains('light shower sleet') ||
        condition.toLowerCase().contains('shower sleet') ||
        condition.toLowerCase().contains('light rain and snow') ||
        condition.toLowerCase().contains('rain and snow') ||
        condition.toLowerCase().contains('light shower snow') ||
        condition.toLowerCase().contains('shower snow') ||
        condition.toLowerCase().contains('heavy shower snow')) {
      return 'assets/lotties/snow.json';
    } else if (condition.toLowerCase().contains('few clouds') ||
        condition.toLowerCase().contains('scattered clouds') ||
        condition.toLowerCase().contains('broken clouds') ||
        condition.toLowerCase().contains('overcast clouds')) {
      return 'assets/lotties/${prefix}_clouds.json';
    } else if (condition.toLowerCase().contains('mist') ||
        condition.toLowerCase().contains('smoke') ||
        condition.toLowerCase().contains('haze') ||
        condition.toLowerCase().contains('dust whirls') ||
        condition.toLowerCase().contains('fog') ||
        condition.toLowerCase().contains('sand') ||
        condition.toLowerCase().contains('volcanic ash') ||
        condition.toLowerCase().contains('squalls') ||
        condition.toLowerCase().contains('tornado')) {
      return 'assets/lotties/atmosphere.json';
    } else {
      return 'assets/lotties/${prefix}_clear.json';
    }
  }
}
