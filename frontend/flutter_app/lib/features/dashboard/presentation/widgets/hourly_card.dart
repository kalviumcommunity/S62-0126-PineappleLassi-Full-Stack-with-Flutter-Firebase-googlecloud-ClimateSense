import 'package:climate_sense/features/dashboard/data/models/timeline_model.dart';
import 'package:climate_sense/features/dashboard/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class HourlyCard extends StatelessWidget {
  final List<ClimateHour> data;
  const HourlyCard({super.key, required this.data});

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
                Icon(Icons.access_time, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Hourly Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _tableRow('Time', 'Temp', 'AQI', true),
            Divider(color: Colors.white24),
            Column(
              children: data.map((hour) {
                return _tableRow(
                  hour.time,
                  hour.temp.toString(),
                  hour.aqi.toString(),
                  false,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(String time, String temp, String aqi, bool isHeader) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              time,
              style: TextStyle(
                fontSize: 14,
                color: isHeader ? Colors.white60 : Colors.white,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              temp,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              aqi,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
