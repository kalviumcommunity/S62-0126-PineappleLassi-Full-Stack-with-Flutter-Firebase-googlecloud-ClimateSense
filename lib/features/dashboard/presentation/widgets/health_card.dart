import 'package:climate_sense/features/dashboard/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class HealthCard extends StatelessWidget {
  const HealthCard({super.key});

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
                Icon(Icons.health_and_safety, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Health Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _tip(Icons.masks, 'Wear mask outdoors'),
            SizedBox(height: 12),
            _tip(Icons.home, 'Stay indoors'),
            SizedBox(height: 12),
            _tip(Icons.water_drop, 'Stay hydrated'),
          ],
        ),
      ),
    );
  }

  Widget _tip(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        SizedBox(width: 12),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
