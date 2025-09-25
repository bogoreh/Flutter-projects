import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = 'https://api.spoonacular.com/recipes';
  final String apiKey = Constants.apiKey;

  Future<List<Recipe>> searchRecipes(String query, {int number = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/complexSearch?query=$query&number=$number&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .map((recipe) => Recipe.fromJson(recipe))
            .toList();
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }

  Future<List<Recipe>> searchByIngredients(String ingredients, {int number = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/findByIngredients?ingredients=$ingredients&number=$number&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // This endpoint returns limited data, so we need to fetch full recipe details
        List<Recipe> recipes = [];
        for (var recipeData in data) {
          try {
            final fullRecipe = await getRecipeDetails(recipeData['id'].toString());
            recipes.add(fullRecipe);
          } catch (e) {
            print('Error fetching details for recipe ${recipeData['id']}: $e');
          }
        }
        return recipes;
      } else {
        throw Exception('Failed to load recipes by ingredients: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load recipes by ingredients: $e');
    }
  }

  Future<Recipe> getRecipeDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id/information?includeNutrition=true&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Recipe.fromJson(data);
      } else {
        throw Exception('Failed to load recipe details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load recipe details: $e');
    }
  }
}