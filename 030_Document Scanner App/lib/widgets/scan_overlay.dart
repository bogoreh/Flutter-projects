import 'package:flutter/material.dart';

class ScanOverlay extends StatelessWidget {
  const ScanOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: ShapeDecoration(
          shape: _ScannerOverlayShape(),
        ),
      ),
    );
  }
}

class _ScannerOverlayShape extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    const cornerLength = 30.0;
    const cornerWidth = 4.0;
    const scanAreaRatio = 0.7;

    final width = rect.width;
    final scanAreaSize = width * scanAreaRatio;
    final scanAreaRect = Rect.fromCenter(
      center: rect.center,
      width: scanAreaSize,
      height: scanAreaSize * 1.4, // Document aspect ratio
    );

    // Draw background overlay
    final backgroundPaint = Paint()..color = Colors.black54;
    canvas.drawPath(
      Path()
        ..addRect(rect)
        ..addRect(scanAreaRect),
      backgroundPaint,
    );

    // Draw corner borders
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth;

    // Top left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.left, scanAreaRect.top + cornerLength)
        ..lineTo(scanAreaRect.left, scanAreaRect.top)
        ..lineTo(scanAreaRect.left + cornerLength, scanAreaRect.top),
      borderPaint,
    );

    // Top right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.right - cornerLength, scanAreaRect.top)
        ..lineTo(scanAreaRect.right, scanAreaRect.top)
        ..lineTo(scanAreaRect.right, scanAreaRect.top + cornerLength),
      borderPaint,
    );

    // Bottom left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.left, scanAreaRect.bottom - cornerLength)
        ..lineTo(scanAreaRect.left, scanAreaRect.bottom)
        ..lineTo(scanAreaRect.left + cornerLength, scanAreaRect.bottom),
      borderPaint,
    );

    // Bottom right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.right - cornerLength, scanAreaRect.bottom)
        ..lineTo(scanAreaRect.right, scanAreaRect.bottom)
        ..lineTo(scanAreaRect.right, scanAreaRect.bottom - cornerLength),
      borderPaint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}