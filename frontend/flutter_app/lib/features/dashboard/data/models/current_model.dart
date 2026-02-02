class CurrentData {
  final int temp;
  final int humidity;
  final int aqi;
  final String weather;
  final String icon;
  final int stress;
  final List<StressReason> reasons;

  CurrentData({
    required this.temp,
    required this.humidity,
    required this.aqi,
    required this.weather,
    required this.icon,
    required this.stress,
    required this.reasons,
  });

  factory CurrentData.fromJson(Map<String, dynamic> json) {
    return CurrentData(
      temp: json['current']['temp'],
      humidity: json['current']['humidity'],
      aqi: json['current']['aqi'],
      weather: json['current']['weather'],
      icon: json['current']['icon'],
      stress: json['stress']['value'],
      reasons: (json['stress']['reasons'] as List)
          .map((e) => StressReason.fromJson(e))
          .toList(),
    );
  }
}

class StressReason {
  final String type;
  final int value;
  final int impact;
  final String message;

  StressReason({
    required this.type,
    required this.value,
    required this.impact,
    required this.message,
  });

  factory StressReason.fromJson(Map<String, dynamic> json) {
    return StressReason(
      type: json['type'],
      value: (json['value'] as num).toInt(),
      impact: (json['impact'] as num).toInt(),
      message: json['message'],
    );
  }

  @override
  String toString() {
    return 'StressReason(type: $type, value: $value, impact: $impact, message: $message)';
  }
}
