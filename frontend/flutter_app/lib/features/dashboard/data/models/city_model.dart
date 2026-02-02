class CityStress {
  final bool available;
  final String? confidence;
  final int gridCount;
  final int? avgStress;
  final String? trend;

  CityStress({
    required this.available,
    this.confidence,
    required this.gridCount,
    this.avgStress,
    this.trend,
  });

  factory CityStress.fromJson(Map<String, dynamic> json) {
    return CityStress(
      available: json['available'],
      confidence: json['confidence'],
      gridCount: json['grid_count'],
      avgStress: json['avg_stress'],
      trend: json['trend'],
    );
  }
}
