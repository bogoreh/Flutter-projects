class WeatherData {
  final String location;
  final double temperature;
  final String description;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String iconCode;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.iconCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['name'] ?? 'Unknown Location',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      description: json['weather'][0]['description'] ?? 'No description',
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      iconCode: json['weather'][0]['icon'] ?? '01d',
    );
  }
}