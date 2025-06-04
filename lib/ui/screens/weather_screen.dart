import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nimbus/bloc/forecast_bloc.dart';
import 'package:nimbus/bloc/weather_bloc.dart';
import 'package:nimbus/ui/screens/forecast_screen.dart';
import 'package:nimbus/ui/widgets/background_gradient.dart';
import 'package:nimbus/ui/widgets/live_date_time.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<WeatherBloc>().add(FetchWeather());
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            35.w,
            (1.5 * kToolbarHeight).h,
            35.w,
            20.w,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: BackgroundGradient(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherSuccess) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                state.weather.city,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'SAN FRANCISCO',
                                  fontSize: 18.sp,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Good ${state.weather.phase[0].toUpperCase()}${state.weather.phase.substring(1)}!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SAN FRANCISCO',
                                  fontSize: 25.sp,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(height: 25.h),
                            Lottie.asset(state.condition),
                            Text(
                              '${state.weather.temperature.round()}°C',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 55.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              state.weather.condition.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            LiveDateTime(),
                            SizedBox(height: 45.h),
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(),
                                1: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    _buildInfoTile(
                                      'Sunrise',
                                      'assets/images/sunrise.png',
                                      DateFormat.jm().format(
                                        state.weather.sunrise,
                                      ),
                                    ),
                                    _buildInfoTile(
                                      'Sunset',
                                      'assets/images/sunset.png',
                                      DateFormat.jm().format(
                                        state.weather.sunset,
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15.h,
                                      ),
                                      child: Divider(
                                        color: Colors.grey.withAlpha(
                                          (0.5 * 255).round(),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15.h,
                                      ),
                                      child: Divider(
                                        color: Colors.grey.withAlpha(
                                          (0.5 * 255).round(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildInfoTile(
                                      'Temp Max',
                                      'assets/images/tempHigh.png',
                                      '${state.weather.tempMax.round()}°C',
                                    ),
                                    _buildInfoTile(
                                      'Temp Min',
                                      'assets/images/tempLow.png',
                                      '${state.weather.tempMin.round()}°C',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withAlpha(
                                  (0.1 * 255).round(),
                                ),
                                shadowColor: Colors.white.withAlpha(
                                  (0.2 * 255).round(),
                                ),
                                elevation: 8,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                  side: BorderSide(
                                    color: Colors.white.withAlpha(
                                      (0.3 * 255).round(),
                                    ),
                                  ),
                                ),
                                minimumSize: Size(double.infinity, 50.h),
                              ),
                              child: Text(
                                'View 7-Day Forecast',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BlocProvider(
                                          create:
                                              (context) =>
                                                  ForecastBloc()
                                                    ..add(FetchForecast()),
                                          child: const ForecastScreen(),
                                        ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is WeatherFailure) {
                    return Center(
                      child: Text(
                        'Failed to load weather',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String assetPath, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(assetPath, scale: 8),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
