import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bangalore',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'Anekal, Karnataka',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
