import 'package:flutter/material.dart';
import '../../data/models/timeline_model.dart';
import '../../painters/interactive_wave_painter.dart';

class InteractiveWave extends StatelessWidget {
  final List<ClimateHour> data;
  final int selectedIndex;
  final Color color;
  final Function(int) onChanged;

  static const int visiblePoints = 5;

  const InteractiveWave({
    super.key,
    required this.data,
    required this.selectedIndex,
    required this.color,
    required this.onChanged,
  });

  List<ClimateHour> _sampleData(List<ClimateHour> full) {
    if (full.length <= visiblePoints) return full;

    return List.generate(visiblePoints, (i) {
      final index = ((full.length - 1) * i / (visiblePoints - 1)).round();
      return full[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacedData = _sampleData(data);
    final safeIndex = selectedIndex.clamp(0, spacedData.length - 1);

    final width = MediaQuery.of(context).size.width - 40;
    final slotWidth = width / (spacedData.length - 1);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final dx = details.localPosition.dx.clamp(0.0, width);
        final newIndex = (dx / slotWidth).round().clamp(
          0,
          spacedData.length - 1,
        );

        if (newIndex != safeIndex) {
          onChanged(newIndex);
        }
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            /// 🌊 Wave
            CustomPaint(
              size: Size(width, 80),
              painter: InteractiveWavePainter(
                spacedData.map((e) => e.stress.toDouble()).toList(),
                safeIndex,
                color,
              ),
            ),

            /// 🕒 Labels
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: spacedData.asMap().entries.map((entry) {
                  final isSelected = entry.key == safeIndex;
                  final isNow = entry.value.isNow == true;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        Text(
                          entry.value.time,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: Colors.white.withOpacity(
                              isSelected ? 1.0 : 0.5,
                            ),
                          ),
                        ),
                        if (isNow) const SizedBox(height: 4),
                        if (isNow)
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
