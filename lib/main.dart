import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nimbus/bloc/weather_bloc.dart';
import 'package:nimbus/ui/screens/weather_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      builder: (context, child) {
        return BlocProvider(
          create: (context) => WeatherBloc()..add(FetchWeather()),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const WeatherScreen(),
          ),
        );
      },
    );
  }
}
