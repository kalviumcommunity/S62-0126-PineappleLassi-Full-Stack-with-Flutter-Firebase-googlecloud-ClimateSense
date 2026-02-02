import 'package:climate_sense/core/permissions/location_permission_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionNotifier
    extends StateNotifier<LocationPermissionState> {
  LocationPermissionNotifier()
    : super(
        const LocationPermissionState(
          status: LocationStatus.none,
          denialCount: 0,
        ),
      );

  Future<void> check() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(status: LocationStatus.serviceDisabled);
      return;
    }

    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      state = state.copyWith(status: LocationStatus.granted, denialCount: 0);
      return;
    }

    // 🔒 only SET deniedForever, never clear it here
    if (permission == LocationPermission.deniedForever ||
        state.status == LocationStatus.deniedForever) {
      state = state.copyWith(status: LocationStatus.deniedForever);
      return;
    }

    if (state.status == LocationStatus.none && state.denialCount == 0) {
      return;
    }

    state = state.copyWith(status: LocationStatus.denied);
  }

  Future<void> requestPermission() async {
    final result = await Geolocator.requestPermission();

    if (result == LocationPermission.deniedForever) {
      // 🔥 lock permanently
      state = state.copyWith(status: LocationStatus.deniedForever);
      return;
    }

    if (result == LocationPermission.denied) {
      state = state.copyWith(
        denialCount: state.denialCount + 1,
        status: LocationStatus.denied,
      );
      return;
    }

    // granted cases
    await check();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<Map<String, double>> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    return {"lat": position.latitude, "lng": position.longitude};
  }
}
