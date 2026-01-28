import 'package:climate_sense/features/dashboard/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class AQICard extends StatelessWidget {
  final int aqi;

  const AQICard({super.key, required this.aqi});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.air, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Air Quality Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _aqiBar('PM2.5', 85, 150, Colors.orange),
            SizedBox(height: 12),
            _aqiBar('PM10', 120, 250, Colors.red),
            SizedBox(height: 12),
            _aqiBar('NO2', 45, 100, Colors.yellow),
          ],
        ),
      ),
    );
  }

  Widget _aqiBar(String name, int value, int max, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: TextStyle(color: Colors.white)),
            Text(
              '$value',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / max,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
