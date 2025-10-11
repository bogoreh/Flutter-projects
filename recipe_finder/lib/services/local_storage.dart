import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';
import 'dart:convert';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  static const String _favoritesKey = 'favorite_recipes';

  Future<void> saveFavoriteRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteRecipes();
    
    // Check if recipe already exists
    if (!favorites.any((r) => r.id == recipe.id)) {
      favorites.add(recipe);
      await _saveRecipesList(prefs, favorites);
    }
  }

  Future<void> removeFavoriteRecipe(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteRecipes();
    favorites.removeWhere((recipe) => recipe.id == recipeId);
    await _saveRecipesList(prefs, favorites);
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing favorite recipes: $e');
      return [];
    }
  }

  Future<bool> isRecipeFavorite(String recipeId) async {
    final favorites = await getFavoriteRecipes();
    return favorites.any((recipe) => recipe.id == recipeId);
  }

  Future<void> _saveRecipesList(SharedPreferences prefs, List<Recipe> recipes) async {
    final jsonList = recipes.map((recipe) => recipe.toJson()).toList();
    await prefs.setString(_favoritesKey, json.encode(jsonList));
  }
}