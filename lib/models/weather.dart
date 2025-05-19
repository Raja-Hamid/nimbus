class Weather {
  final String city;
  final double temperature;
  final double tempMax;
  final double tempMin;
  final String condition;
  final String phase;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime lastUpdated;

  Weather({
    required this.city,
    required this.temperature,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
    required this.phase,
    required this.sunrise,
    required this.sunset,
    required this.lastUpdated,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final DateTime currentTime = DateTime.fromMillisecondsSinceEpoch(
      json['dt'] * 1000,
    );
    final DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(
      json['sys']['sunrise'] * 1000,
    );
    final DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(
      json['sys']['sunset'] * 1000,
    );

    String getPhase(DateTime now) {
      final hour = now.hour;
      if (hour >= 5 && hour < 12) return 'morning';
      if (hour >= 12 && hour < 17) return 'afternoon';
      if (hour >= 17 && hour < 20) return 'evening';
      return 'night';
    }

    return Weather(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      condition: json['weather'][0]['description'],
      phase: getPhase(currentTime),
      sunrise: sunriseTime,
      sunset: sunsetTime,
      lastUpdated: currentTime,
    );
  }
}
