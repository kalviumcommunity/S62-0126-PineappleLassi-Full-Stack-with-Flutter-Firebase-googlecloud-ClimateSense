import 'package:climate_sense/features/dashboard/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import '../../data/models/current_model.dart';

class ReasonCard extends StatelessWidget {
  final CurrentData data;

  const ReasonCard({super.key, required this.data});

  String iconForType(String type) {
    switch (type) {
      case 'air_quality':
        return '🌫️';
      case 'temperature':
        return '🌡️';
      case 'humidity':
        return '💧';
      default:
        return '⚠️';
    }
  }

  String titleForType(String type) {
    switch (type) {
      case 'air_quality':
        return 'Poor Air Quality';
      case 'temperature':
        return 'High Temperature';
      case 'humidity':
        return 'High Humidity';
      default:
        return 'Climate Factor';
    }
  }

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
                Icon(Icons.info_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Why This Stress Level?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            Column(
              children: data.reasons.map((reason) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _item(
                    iconForType(reason.type),
                    titleForType(reason.type),
                    '${reason.value}',
                    reason.message, // 🔥 real backend message
                  ),
                );
              }).toList(),
            ),
            _item(
              '🧑',
              'Citizen Reports',
              '2 nearby',
              'Multiple users reported climate concerns',
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String emoji, String title, String value, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(emoji, style: TextStyle(fontSize: 20)),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
