import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nimbus/models/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:nimbus/services/weather_service.dart';
import 'package:nimbus/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService weatherService = WeatherService();

  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final Position position = await LocationService.getCurrentLocation();
        final Weather weather = await weatherService.fetchWeather(position);
        final String condition = weatherService.getWeatherCondition(weather);
        emit(WeatherSuccess(weather, condition));
      } catch (e) {
        emit(WeatherFailure());
      }
    });
  }
}
