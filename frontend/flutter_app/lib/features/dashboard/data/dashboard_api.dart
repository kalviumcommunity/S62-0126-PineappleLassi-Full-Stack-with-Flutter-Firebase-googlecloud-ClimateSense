import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/current_model.dart';
import 'models/timeline_model.dart';
import 'models/city_model.dart';

class DashboardApi {
  final String baseUrl;

  DashboardApi(this.baseUrl);

  Future<CurrentData> fetchCurrent(double lat, double lng) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/dashboard/current?lat=$lat&lng=$lng'),
    );
    return CurrentData.fromJson(json.decode(res.body));
  }

  Future<List<ClimateHour>> fetchTimeline(double lat, double lng) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/dashboard/timeline?lat=$lat&lng=$lng'),
    );

    final data = json.decode(res.body)['hourly'] as List;
    return data.map((e) => ClimateHour.fromJson(e)).toList();
  }

  Future<CityStress> fetchCityStress(String city) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/city/stress?city=$city'),
    );
    return CityStress.fromJson(json.decode(res.body));
  }
}
