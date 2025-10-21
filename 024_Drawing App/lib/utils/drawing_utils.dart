import 'dart:math';
import 'package:flutter/material.dart';

// Utility functions for drawing operations
class DrawingUtils {
  static double calculateDistance(Offset point1, Offset point2) {
    final dx = point1.dx - point2.dx;
    final dy = point1.dy - point2.dy;
    return sqrt(dx * dx + dy * dy);
  }

  static bool isPointInCircle(Offset point, Offset center, double radius) {
    return calculateDistance(point, center) <= radius;
  }

  static Offset calculateMidpoint(Offset point1, Offset point2) {
    return Offset(
      (point1.dx + point2.dx) / 2,
      (point1.dy + point2.dy) / 2,
    );
  }

  static double calculateLineLength(List<Offset> points) {
    if (points.length < 2) return 0.0;
    
    double totalLength = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      totalLength += calculateDistance(points[i], points[i + 1]);
    }
    return totalLength;
  }

  static Rect calculateBoundingBox(List<DrawingPoint> points) {
    if (points.isEmpty) {
      return Rect.zero;
    }

    double minX = points.first.offset.dx;
    double maxX = points.first.offset.dx;
    double minY = points.first.offset.dy;
    double maxY = points.first.offset.dy;

    for (final point in points) {
      minX = min(minX, point.offset.dx);
      maxX = max(maxX, point.offset.dx);
      minY = min(minY, point.offset.dy);
      maxY = max(maxY, point.offset.dy);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}