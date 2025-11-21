import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherIcon({
    super.key,
    required this.iconCode,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://openweathermap.org/img/wn/$iconCode@2x.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          _getFallbackIcon(),
          size: size,
          color: Colors.amber,
        );
      },
    );
  }

  IconData _getFallbackIcon() {
    if (iconCode.contains('01')) return Icons.wb_sunny;
    if (iconCode.contains('02')) return Icons.wb_cloudy;
    if (iconCode.contains('03') || iconCode.contains('04')) return Icons.cloud;
    if (iconCode.contains('09') || iconCode.contains('10')) return Icons.beach_access;
    if (iconCode.contains('11')) return Icons.flash_on;
    if (iconCode.contains('13')) return Icons.ac_unit;
    if (iconCode.contains('50')) return Icons.blur_on;
    return Icons.wb_sunny;
  }
}