import 'recipe.dart';

class ApiResponse {
  final List<Recipe> results;
  final int offset;
  final int number;
  final int totalResults;

  ApiResponse({
    required this.results,
    required this.offset,
    required this.number,
    required this.totalResults,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      results: (json['results'] as List? ?? [])
          .map((recipe) => Recipe.fromJson(recipe))
          .toList(),
      offset: json['offset'] ?? 0,
      number: json['number'] ?? 0,
      totalResults: json['totalResults'] ?? 0,
    );
  }
}