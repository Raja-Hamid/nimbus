import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LiveDateTime extends StatefulWidget {
  const LiveDateTime({super.key});

  @override
  State<LiveDateTime> createState() => _LiveDateTimeState();
}

class _LiveDateTimeState extends State<LiveDateTime> {
  late final Stream<DateTime> _timeStream;

  Stream<DateTime> _getTimeStream() async* {
    while (true) {
      yield DateTime.now();
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  void initState() {
    super.initState();
    _timeStream = _getTimeStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _timeStream,
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final formatted = DateFormat('EEEE d - hh:mm a')
            .format(now)
            .replaceAllMapped(
          RegExp(r'AM|PM'),
              (match) => match.group(0)!.toLowerCase(),
        );
        return Text(
          formatted,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}