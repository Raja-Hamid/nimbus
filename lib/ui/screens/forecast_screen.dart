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
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: forecast.length,
                        itemBuilder: (_, i) => _buildForecastCard(forecast[i]),
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
    );
  }

  Widget _buildForecastCard(Forecast day) {
    final dateStr = DateFormat('EEE, MMM d').format(day.day);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(18.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.06 * 255).round()),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withAlpha((0.15 * 255).round())),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withAlpha((0.05 * 255).round()),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  day.conditionLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildChip('🌡 Avg', '${day.tAvg}°C')),
              SizedBox(width: 8.w),
              Expanded(child: _buildChip('🔻 Min', '${day.tMin}°C')),
              SizedBox(width: 8.w),
              Expanded(child: _buildChip('🔺 Max', '${day.tMax}°C')),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🌧 Rain: ${day.prcp}mm',
                style: TextStyle(color: Colors.white70, fontSize: 13.sp),
              ),
              Text(
                '💨 Wind: ${day.wspd} km/h',
                style: TextStyle(color: Colors.white70, fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildIconLabel("☀", day.probSunny)),
              Expanded(child: _buildIconLabel("☁", day.probCloudy)),
              Expanded(child: _buildIconLabel("🌧", day.probRainy)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Text(
          '$label\n$value',
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      ),
    );
  }

  Widget _buildIconLabel(String emoji, double percent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: TextStyle(fontSize: 15.sp)),
        SizedBox(width: 4.w),
        Text(
          '${percent.toStringAsFixed(1)}%',
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      ],
    );
  }
}
