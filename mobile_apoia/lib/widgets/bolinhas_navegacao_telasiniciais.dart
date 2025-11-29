import 'package:flutter/material.dart';

Widget buildDot(Color color) {
  return Container(
    width: 12,
    height: 12,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
