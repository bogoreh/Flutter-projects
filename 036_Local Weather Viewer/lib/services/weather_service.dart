import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Using a demo API key - replace with your own from openweathermap.org
  static const String apiKey = '40c42f9eed351677d71026af3d58b96d';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // For demo purposes, we'll use a fixed location (London)
  // In a real app, you would use geolocator here
  Future<WeatherData> getWeatherData() async {
    try {
      // Using fixed coordinates for London as fallback
      final response = await http.get(
        Uri.parse(
          '$baseUrl/weather?q=London&appid=$apiKey&units=metric',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherData.fromJson(data);
      } else {
        // Fallback to mock data if API fails
        return _getMockWeatherData();
      }
    } catch (e) {
      // Return mock data in case of any error
      return _getMockWeatherData();
    }
  }

  WeatherData _getMockWeatherData() {
    return WeatherData(
      location: 'London',
      temperature: 18.5,
      description: 'Partly cloudy',
      feelsLike: 17.8,
      humidity: 65,
      windSpeed: 3.2,
      pressure: 1013,
      iconCode: '02d',
    );
  }
}