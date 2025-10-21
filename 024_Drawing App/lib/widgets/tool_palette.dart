import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'brush_size_slider.dart';

class ToolPalette extends StatelessWidget {
  final Color selectedColor;
  final double strokeWidth;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<double> onStrokeWidthChanged;

  const ToolPalette({
    super.key,
    required this.selectedColor,
    required this.strokeWidth,
    required this.onColorChanged,
    required this.onStrokeWidthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Color Palette
          ColorPalette(
            selectedColor: selectedColor,
            onColorSelected: onColorChanged,
          ),
          const SizedBox(height: 16),
          
          // Brush Size Slider
          BrushSizeSlider(
            strokeWidth: strokeWidth,
            onStrokeWidthChanged: onStrokeWidthChanged,
          ),
        ],
      ),
    );
  }
}