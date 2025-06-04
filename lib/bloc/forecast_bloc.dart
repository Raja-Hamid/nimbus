import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nimbus/models/forecast.dart';
import 'package:nimbus/services/forecast_service.dart';
import 'package:nimbus/services/location_service.dart';

part 'forecast_event.dart';
part 'forecast_state.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  ForecastBloc() : super(ForecastInitial()) {
    on<FetchForecast>(_onFetchForecast);
  }

  Future<void> _onFetchForecast(
    FetchForecast event,
    Emitter<ForecastState> emit,
  ) async {
    emit(ForecastLoading());
    try {
      final position = await LocationService.getCurrentLocation();
      final forecast = await ForecastService.fetchForecast(position);
      emit(ForecastSuccess(forecast));
    } catch (e) {
      emit(ForecastFailure(e.toString()));
    }
  }
}
