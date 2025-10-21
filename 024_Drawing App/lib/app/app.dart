import 'package:flutter/material.dart';
import '../models/drawing_point.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/tool_palette.dart';

class ArtCanvasApp extends StatefulWidget {
  const ArtCanvasApp({super.key});

  @override
  State<ArtCanvasApp> createState() => _ArtCanvasAppState();
}

class _ArtCanvasAppState extends State<ArtCanvasApp> {
  Color selectedColor = Colors.blue;
  double strokeWidth = 3.0;
  List<DrawingPoint> points = [];
  List<List<DrawingPoint>> history = [];

  void _clearCanvas() {
    setState(() {
      history.add(List.from(points));
      points.clear();
    });
  }

  void _undo() {
    if (history.isNotEmpty) {
      setState(() {
        points = history.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ArtCanvas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _undo,
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearCanvas,
            tooltip: 'Clear Canvas',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tool Palette
          ToolPalette(
            selectedColor: selectedColor,
            strokeWidth: strokeWidth,
            onColorChanged: (color) => setState(() => selectedColor = color),
            onStrokeWidthChanged: (width) => setState(() => strokeWidth = width),
          ),
          
          // Drawing Canvas
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: DrawingCanvas(
                  points: points,
                  selectedColor: selectedColor,
                  strokeWidth: strokeWidth,
                  onPointsUpdate: (newPoints) {
                    setState(() => points = newPoints);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}