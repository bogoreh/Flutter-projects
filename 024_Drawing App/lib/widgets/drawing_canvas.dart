import 'package:flutter/material.dart';
import '../models/drawing_point.dart';

class DrawingCanvas extends StatefulWidget {
  final List<DrawingPoint> points;
  final Color selectedColor;
  final double strokeWidth;
  final Function(List<DrawingPoint>) onPointsUpdate;

  const DrawingCanvas({
    super.key,
    required this.points,
    required this.selectedColor,
    required this.strokeWidth,
    required this.onPointsUpdate,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<DrawingPoint> currentPoints = [];

  void _onPanStart(DragStartDetails details) {
    final paint = Paint()
      ..color = widget.selectedColor
      ..strokeWidth = widget.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    setState(() {
      currentPoints.add(DrawingPoint(
        offset: details.localPosition,
        paint: paint,
      ));
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      currentPoints.add(DrawingPoint(
        offset: details.localPosition,
        paint: currentPoints.last.paint,
      ));
    });
  }

  void _onPanEnd(DragEndDetails details) {
    widget.onPointsUpdate([...widget.points, ...currentPoints]);
    setState(() {
      currentPoints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        size: Size.infinite,
        painter: DrawingPainter(
          points: [...widget.points, ...currentPoints],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i + 1].offset != points[i].offset) {
        canvas.drawLine(
          points[i].offset,
          points[i + 1].offset,
          points[i].paint,
        );
        
        // Draw circles at points for better visual connection
        canvas.drawCircle(
          points[i].offset,
          points[i].paint.strokeWidth / 2,
          points[i].paint,
        );
      }
    }

    // Draw circle at the last point
    if (points.isNotEmpty) {
      canvas.drawCircle(
        points.last.offset,
        points.last.paint.strokeWidth / 2,
        points.last.paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}