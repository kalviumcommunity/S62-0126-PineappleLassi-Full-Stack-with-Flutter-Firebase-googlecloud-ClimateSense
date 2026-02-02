import 'package:climate_sense/features/dashboard/data/models/timeline_model.dart';
import 'package:climate_sense/features/dashboard/data/models/city_model.dart';
import 'package:climate_sense/features/dashboard/data/models/current_model.dart';

class DashboardState {
  final bool isLoading;
  final CurrentData? current;
  final List<ClimateHour>? timeline;
  final CityStress? city;

  DashboardState({
    required this.isLoading,
    this.current,
    this.timeline,
    this.city,
  });

  factory DashboardState.loading() {
    return DashboardState(isLoading: true);
  }
}
