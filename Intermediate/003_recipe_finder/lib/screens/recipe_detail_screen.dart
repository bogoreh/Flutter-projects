import 'package:flutter/material.dart';
import '../widgets/ingredient_list.dart';
import '../widgets/instruction_step.dart';
import '../models/recipe.dart';
import '../services/local_storage.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final LocalStorage _localStorage = LocalStorage();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final isFavorite = await _localStorage.isRecipeFavorite(widget.recipe.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  void _toggleFavorite() async {
  if (_isFavorite) {
    await _localStorage.removeFavoriteRecipe(widget.recipe.id);
  } else {
    await _localStorage.saveFavoriteRecipe(widget.recipe); // Fixed: pass recipe object, not just ID
  }
  setState(() {
    _isFavorite = !_isFavorite;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.recipe.image.isNotEmpty
                  ? Image.network(
                      widget.recipe.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.fastfood, size: 100),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.fastfood, size: 100),
                    ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(width: 4),
                      Text('${widget.recipe.readyInMinutes} minutes'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (widget.recipe.extendedIngredients.isNotEmpty)
                    IngredientList(ingredients: widget.recipe.extendedIngredients),
                  
                  const SizedBox(height: 24),
                  if (widget.recipe.analyzedInstructions.isNotEmpty) ...[
                    const Text(
                      'Instructions',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...widget.recipe.analyzedInstructions.expand((instruction) => 
                      instruction.steps.map((step) => InstructionStep(step: step))
                    ).toList(),
                  ],
                  
                  const SizedBox(height: 24),
                  if (widget.recipe.nutrition != null) ...[
                    const Text(
                      'Nutrition',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...widget.recipe.nutrition!.nutrients.take(5).map((nutrient) => 
                      ListTile(
                        title: Text(nutrient.name),
                        trailing: Text('${nutrient.amount.toStringAsFixed(1)} ${nutrient.unit}'),
                        dense: true,
                      )
                    ).toList(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}