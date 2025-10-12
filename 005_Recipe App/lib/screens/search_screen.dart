import 'package:flutter/material.dart';
import '../widgets/recipe_card.dart';
import '../services/api_service.dart';
import '../services/local_storage.dart';
import 'recipe_detail_screen.dart';
import '../models/recipe.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final LocalStorage _localStorage = LocalStorage();
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _searchResults = [];
  bool _isSearching = false;
  bool _searchByIngredients = false;
  String _lastSearchQuery = '';

  void _searchRecipes(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _lastSearchQuery = query;
    });

    try {
      List<Recipe> results;
      if (_searchByIngredients) {
        results = await _apiService.searchByIngredients(query);
      } else {
        results = await _apiService.searchRecipes(query);
      }

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    }
  }

  void _navigateToRecipeDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _searchByIngredients 
                        ? 'Enter ingredients (comma separated)'
                        : 'Search recipes...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _searchRecipes(_searchController.text),
                    ),
                  ),
                  onSubmitted: _searchRecipes,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Search by ingredients:'),
                    Switch(
                      value: _searchByIngredients,
                      onChanged: (value) {
                        setState(() {
                          _searchByIngredients = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isSearching)
            const Center(child: CircularProgressIndicator())
          else if (_searchResults.isEmpty && _lastSearchQuery.isNotEmpty)
            const Center(child: Text('No recipes found'))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final recipe = _searchResults[index];
                  return RecipeCard(
                    recipe: recipe,
                    onTap: () => _navigateToRecipeDetails(recipe),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}