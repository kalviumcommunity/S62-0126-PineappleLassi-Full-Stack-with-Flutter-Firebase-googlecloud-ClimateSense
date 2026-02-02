enum LocationStatus { none, granted, denied, deniedForever, serviceDisabled }

class LocationPermissionState {
  final LocationStatus status;
  final int denialCount;

  const LocationPermissionState({
    required this.status,
    required this.denialCount,
  });

  LocationPermissionState copyWith({LocationStatus? status, int? denialCount}) {
    return LocationPermissionState(
      status: status ?? this.status,
      denialCount: denialCount ?? this.denialCount,
    );
  }
}
