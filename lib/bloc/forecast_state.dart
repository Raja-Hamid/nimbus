part of 'forecast_bloc.dart';

sealed class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object?> get props => [];
}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastSuccess extends ForecastState {
  final List<Forecast> forecast;

  const ForecastSuccess(this.forecast);

  @override
  List<Object?> get props => [forecast];
}

class ForecastFailure extends ForecastState {
  final String message;

  const ForecastFailure(this.message);

  @override
  List<Object?> get props => [message];
}
