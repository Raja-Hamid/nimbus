import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nimbus/bloc/forecast_bloc.dart';
import 'package:nimbus/models/forecast.dart';
import 'package:nimbus/ui/widgets/background_gradient.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          35.w,
          (1.5 * kToolbarHeight).h,
          35.w,
          20.w,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BackgroundGradient(
            child: BlocBuilder<ForecastBloc, ForecastState>(
              builder: (context, state) {
                if (state is ForecastLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ForecastFailure) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    ),
                  );
                } else if (state is ForecastSuccess) {
                  final forecast = state.forecast;
                  return Column(
                    children: [
                      Text(
                        '7-Day Forecast',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: forecast.length,
                          itemBuilder:
                              (_, i) => _buildForecastCard(forecast[i]),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForecastCard(Forecast day) {
    final dateStr = DateFormat('EEE, MMM d').format(day.day);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withAlpha((0.2 * 255).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$dateStr - ${day.conditionLabel}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Avg: ${day.tAvg}°C, Min: ${day.tMin}°C, Max: ${day.tMax}°C\nRain: ${day.prcp}mm, Wind: ${day.wspd} km/h',
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "☀ ${day.probSunny.toStringAsFixed(1)}%  ",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "☁ ${day.probCloudy.toStringAsFixed(1)}%  ",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "🌧 ${day.probRainy.toStringAsFixed(1)}%",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
