import 'package:flutter/material.dart';

class BrushSizeSlider extends StatelessWidget {
  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthChanged;

  const BrushSizeSlider({
    super.key,
    required this.strokeWidth,
    required this.onStrokeWidthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.brush, size: 20),
            const SizedBox(width: 8),
            Text(
              'Brush Size',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${strokeWidth.toStringAsFixed(1)}px',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: strokeWidth,
          min: 1,
          max: 20,
          divisions: 19,
          onChanged: onStrokeWidthChanged,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ],
    );
  }
}