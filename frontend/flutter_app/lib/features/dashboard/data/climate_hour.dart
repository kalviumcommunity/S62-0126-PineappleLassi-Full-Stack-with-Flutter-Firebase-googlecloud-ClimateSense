import 'package:flutter/material.dart';

class ClimateHour {
  final String time;
  final int temp;
  final int stress;
  final int aqi;
  final IconData weatherIcon;
  final bool isNow;

  const ClimateHour({
    required this.time,
    required this.temp,
    required this.stress,
    required this.aqi,
    required this.weatherIcon,
    this.isNow = false,
  });
}
