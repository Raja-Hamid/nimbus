part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final Weather weather;
  final String condition;
  const WeatherSuccess(this.weather, this.condition);

  @override
  List<Object> get props => [weather, condition];
}

class WeatherFailure extends WeatherState {}
