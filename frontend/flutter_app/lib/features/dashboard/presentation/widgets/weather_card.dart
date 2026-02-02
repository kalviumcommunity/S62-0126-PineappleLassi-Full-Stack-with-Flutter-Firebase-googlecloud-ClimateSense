import 'package:climate_sense/features/dashboard/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import '../../data/models/timeline_model.dart';

class WeatherCard extends StatelessWidget {
  final ClimateHour data;

  const WeatherCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.network(
                      data.icon,
                      width: 24,
                      height: 24,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.cloud,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    SizedBox(width: 8),
                    Text(
                      'Current Weather',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Sunny',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Image.network(
                        data.icon,
                        width: 24,
                        height: 24,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.cloud,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '${data.temp}°C',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Text(
                        'Feels like ${data.temp + 4}°C',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _weatherStat('🌫️', 'AQI', '${data.aqi}'),
                      SizedBox(height: 10),
                      _weatherStat('💨', 'Wind', '12 km/h'),
                      SizedBox(height: 10),
                      _weatherStat('💧', 'Humid', '68%'),
                      SizedBox(height: 10),
                      _weatherStat('☀️', 'UV', '9'),
                      SizedBox(height: 10),
                      _weatherStat('🔽', 'Press', '1013'),
                      SizedBox(height: 10),
                      _weatherStat('👁️', 'Vis', '10km'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white24),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _sunTime(Icons.wb_twilight, 'Sunrise', '6:15 AM'),
                _sunTime(Icons.wb_sunny, 'Sunset', '6:45 PM'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _weatherStat(String emoji, String label, String value) {
  return Row(
    children: [
      Text(emoji, style: TextStyle(fontSize: 16)),
      SizedBox(width: 6),
      Expanded(
        child: Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white60),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  );
}

Widget _sunTime(IconData icon, String label, String time) {
  return Column(
    children: [
      Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6)),
      ),
      Text(
        time,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  );
}
