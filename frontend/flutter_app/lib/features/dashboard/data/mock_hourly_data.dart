import 'package:flutter/material.dart';
import 'climate_hour.dart';

const hourlyData = [
  ClimateHour(
    time: '10AM',
    temp: 32,
    stress: 45,
    aqi: 120,
    weatherIcon: Icons.wb_sunny,
  ),
  ClimateHour(
    time: '12PM',
    temp: 35,
    stress: 62,
    aqi: 165,
    weatherIcon: Icons.wb_sunny_outlined,
  ),
  ClimateHour(
    time: 'Now',
    temp: 38,
    stress: 75,
    aqi: 190,
    weatherIcon: Icons.local_fire_department,
    isNow: true,
  ),
  ClimateHour(
    time: '4PM',
    temp: 36,
    stress: 68,
    aqi: 175,
    weatherIcon: Icons.cloud_outlined,
  ),
  ClimateHour(
    time: '6PM',
    temp: 32,
    stress: 52,
    aqi: 145,
    weatherIcon: Icons.cloud,
  ),
];
