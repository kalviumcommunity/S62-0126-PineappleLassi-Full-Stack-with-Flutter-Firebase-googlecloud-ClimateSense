// lib/widgets/dashboard/trend_card.dart

import 'package:climate_sense/features/dashboard/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import '../../painters/trend_painter.dart';
import '../../data/models/timeline_model.dart';

class TrendCard extends StatelessWidget {
  final List<ClimateHour> data;
  final Color color;

  const TrendCard({super.key, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    final temps = data.map((e) => e.temp).toList();

    // Calculate insights
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final avgTemp = (temps.reduce((a, b) => a + b) / temps.length).round();

    final minIndex = temps.indexOf(minTemp);
    final maxIndex = temps.indexOf(maxTemp);

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final minDay = minIndex < days.length ? days[minIndex] : '';
    final maxDay = maxIndex < days.length ? days[maxIndex] : '';

    // Determine trend
    final firstHalf = temps.take(temps.length ~/ 2).reduce((a, b) => a + b);
    final secondHalf = temps.skip(temps.length ~/ 2).reduce((a, b) => a + b);
    final trendIcon = secondHalf > firstHalf
        ? '↗️'
        : (secondHalf < firstHalf ? '↘️' : '→');
    final trendText = secondHalf > firstHalf
        ? 'Rising'
        : (secondHalf < firstHalf ? 'Falling' : 'Stable');

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: const [
                Icon(Icons.trending_up, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Temperature Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Graph
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: TrendPainter(temps: temps, color: color),
              ),
            ),

            const SizedBox(height: 20),

            // Insights Row
            Row(
              children: [
                Expanded(
                  child: _InsightChip(
                    icon: '🔥',
                    label: 'Peak',
                    value: '$maxTemp°C',
                    subtitle: maxDay,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InsightChip(
                    icon: '❄️',
                    label: 'Low',
                    value: '$minTemp°C',
                    subtitle: minDay,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _InsightChip(
                    icon: '📊',
                    label: 'Average',
                    value: '$avgTemp°C',
                    subtitle: '7 days',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InsightChip(
                    icon: trendIcon,
                    label: 'Trend',
                    value: trendText,
                    subtitle: 'This week',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// INSIGHT CHIP WIDGET
// ============================================================================
class _InsightChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _InsightChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
