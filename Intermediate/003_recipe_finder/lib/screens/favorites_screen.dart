import 'package:flutter/material.dart';
import '../widgets/recipe_card.dart';
import '../services/local_storage.dart';
import 'recipe_detail_screen.dart';
import '../models/recipe.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final LocalStorage _localStorage = LocalStorage();
  List<Recipe> _favoriteRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _localStorage.getFavoriteRecipes();
    setState(() {
      _favoriteRecipes = favorites;
      _isLoading = false;
    });
  }

  void _navigateToRecipeDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    ).then((_) => _loadFavorites()); // Reload when returning
  }

  void _removeFavorite(Recipe recipe) async {
    await _localStorage.removeFavoriteRecipe(recipe.id);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteRecipes.isEmpty
              ? const Center(
                  child: Text(
                    'No favorite recipes yet!\nSearch for recipes and tap the heart icon to save them.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: ListView.builder(
                    itemCount: _favoriteRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _favoriteRecipes[index];
                      return Dismissible(
                        key: Key(recipe.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) => _removeFavorite(recipe),
                        child: RecipeCard(
                          recipe: recipe,
                          onTap: () => _navigateToRecipeDetails(recipe),
                          isFavorite: true,
                          onFavoriteToggle: () => _removeFavorite(recipe),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}