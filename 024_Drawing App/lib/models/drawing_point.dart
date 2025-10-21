import 'package:flutter/material.dart';

class DrawingPoint {
  final Offset offset;
  final Paint paint;
  final DateTime timestamp;

  DrawingPoint({
    required this.offset,
    required this.paint,
  }) : timestamp = DateTime.now();

  DrawingPoint copyWith({
    Offset? offset,
    Paint? paint,
  }) {
    return DrawingPoint(
      offset: offset ?? this.offset,
      paint: paint ?? this.paint,
    );
  }
}