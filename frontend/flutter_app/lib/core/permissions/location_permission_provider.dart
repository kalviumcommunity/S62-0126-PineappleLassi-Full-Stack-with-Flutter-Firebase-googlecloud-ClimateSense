import 'package:flutter_riverpod/legacy.dart';
import 'location_permission_notifier.dart';
import 'location_permission_state.dart';

final locationPermissionProvider =
    StateNotifierProvider<LocationPermissionNotifier, LocationPermissionState>(
      (ref) => LocationPermissionNotifier(),
    );
