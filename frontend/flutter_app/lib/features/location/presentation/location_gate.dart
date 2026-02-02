import 'package:climate_sense/core/permissions/location_permission_provider.dart';
import 'package:climate_sense/core/permissions/location_permission_state.dart';
import 'package:climate_sense/features/auth/presentation/navigation_page.dart';
import 'package:climate_sense/features/location/presentation/initial_permission_screen.dart';
import 'package:climate_sense/features/location/presentation/location_denied_forever.dart';
import 'package:climate_sense/features/location/presentation/location_denied_screen.dart';
import 'package:climate_sense/features/location/presentation/location_service_off_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationGate extends ConsumerStatefulWidget {
  const LocationGate({super.key});

  @override
  ConsumerState<LocationGate> createState() => _LocationGateState();
}

class _LocationGateState extends ConsumerState<LocationGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initial permission sync
    Future.microtask(() {
      ref.read(locationPermissionProvider.notifier).check();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 🔥 Called when returning from Settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(locationPermissionProvider.notifier).check();
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionState = ref.watch(locationPermissionProvider);
    final notifier = ref.read(locationPermissionProvider.notifier);

    // ✅ OS-level granted always wins
    if (permissionState.status == LocationStatus.granted) {
      return const NavigationPage();
    }

    // ✅ GPS off has priority
    if (permissionState.status == LocationStatus.serviceDisabled) {
      return LocationServiceOffScreen(
        onEnableGPS: notifier.openLocationSettings,
      );
    }

    if (permissionState.status == LocationStatus.deniedForever) {
      return LocationDeniedForeverScreen(
        onOpenSettings: notifier.openAppSettings,
      );
    }

    // 🔥 UX-level “stop asking” (device-agnostic)
    if (permissionState.denialCount >= 2) {
      return LocationDeniedForeverScreen(
        onOpenSettings: notifier.openAppSettings,
      );
    }

    if (permissionState.status == LocationStatus.denied) {
      return LocationDeniedScreen(onRetry: notifier.requestPermission);
    }

    // Default ask screen
    return InitialLocationPermissionScreen(
      onGrantAccess: notifier.requestPermission,
    );
  }
}
