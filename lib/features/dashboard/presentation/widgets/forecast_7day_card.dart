import 'package:climate_sense/features/dashboard/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class Forecast7DayCard extends StatelessWidget {
  const Forecast7DayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final days = [
      {'day': 'Mon', 'icon': Icons.local_fire_department, 'temp': 38},
      {'day': 'Tue', 'icon': Icons.cloud_outlined, 'temp': 36},
      {'day': 'Wed', 'icon': Icons.cloud, 'temp': 32},
      {'day': 'Thu', 'icon': Icons.grain, 'temp': 30},
      {'day': 'Fri', 'icon': Icons.grain, 'temp': 28},
      {'day': 'Sat', 'icon': Icons.cloud, 'temp': 31},
      {'day': 'Sun', 'icon': Icons.wb_sunny, 'temp': 34},
    ];

    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  '7-Day Forecast',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...days.map(
              (d) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        d['day'] as String,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Icon(
                      d['icon'] as IconData,
                      color: Colors.white70,
                      size: 24,
                    ),
                    Text(
                      '${d['temp']}°',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
