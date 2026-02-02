class ClimateHour {
  final String time;
  final int temp;
  final int stress;
  final int aqi;
  final String icon;
  final bool isNow;

  ClimateHour({
    required this.time,
    required this.temp,
    required this.stress,
    required this.aqi,
    required this.icon,
    required this.isNow,
  });

  factory ClimateHour.fromJson(Map<String, dynamic> json) {
    return ClimateHour(
      time: json['time'],
      temp: json['temp'],
      stress: json['stress'],
      aqi: json['aqi'],
      icon: json['icon'],
      isNow: json['is_now'],
    );
  }
}
