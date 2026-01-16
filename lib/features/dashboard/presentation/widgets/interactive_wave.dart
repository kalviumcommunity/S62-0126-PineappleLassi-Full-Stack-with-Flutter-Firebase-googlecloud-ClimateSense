import 'package:flutter/material.dart';
import '../../data/climate_hour.dart';
import '../../painters/interactive_wave_painter.dart';

class InteractiveWave extends StatelessWidget {
  final List<ClimateHour> data;
  final int selectedIndex;
  final Color color;
  final Function(int) onChanged;

  const InteractiveWave({
    super.key,
    required this.data,
    required this.selectedIndex,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final width = MediaQuery.of(context).size.width - 40;
        final position = (details.localPosition.dx / width * (data.length - 1))
            .clamp(0, data.length - 1);
        final newIndex = position.round();
        if (newIndex != selectedIndex) onChanged(newIndex);
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width - 40, 100),
              painter: InteractiveWavePainter(
                data.map((e) => (e.stress).toDouble()).toList(),
                selectedIndex,
                color,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: data.asMap().entries.map((entry) {
                  final isSelected = entry.key == selectedIndex;
                  final isNow = entry.value.isNow == true;
                  return Column(
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
                      if (isNow) SizedBox(height: 2),
                      if (isNow)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
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
