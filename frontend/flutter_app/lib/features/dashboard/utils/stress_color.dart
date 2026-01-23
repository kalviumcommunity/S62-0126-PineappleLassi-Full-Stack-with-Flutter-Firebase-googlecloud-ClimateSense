import 'package:flutter/material.dart';

Color getStressColor(int stress) {
  if (stress < 30) return Colors.green;
  if (stress < 60) return Colors.orange;
  return Colors.deepOrange;
}
