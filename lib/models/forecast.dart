class Forecast {
  final DateTime day;
  final double tAvg, tMin, tMax, prcp, wspd;
  final String conditionLabel;
  final double probSunny, probCloudy, probRainy;

  Forecast({
    required this.day,
    required this.tAvg,
    required this.tMin,
    required this.tMax,
    required this.prcp,
    required this.wspd,
    required this.conditionLabel,
    required this.probSunny,
    required this.probCloudy,
    required this.probRainy,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final c = json['condition'];
    final probs = c['probabilities'];
    return Forecast(
      day: DateTime.parse(json['day']),
      tAvg: (json['tavg'] as num).toDouble(),
      tMin: (json['tmin'] as num).toDouble(),
      tMax: (json['tmax'] as num).toDouble(),
      prcp: (json['prcp'] as num).toDouble(),
      wspd: (json['wspd'] as num).toDouble(),
      conditionLabel: c['label'],
      probSunny: (probs['Sunny'] as num).toDouble(),
      probCloudy: (probs['Cloudy'] as num).toDouble(),
      probRainy: (probs['Rainy'] as num).toDouble(),
    );
  }
}
