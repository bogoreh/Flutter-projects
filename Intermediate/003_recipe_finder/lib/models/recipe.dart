class Recipe {
  final String id;
  final String title;
  final String image;
  final String summary;
  final int readyInMinutes;
  final List<Ingredient> extendedIngredients;
  final List<AnalyzedInstruction> analyzedInstructions;
  final Nutrition? nutrition;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.summary,
    required this.readyInMinutes,
    required this.extendedIngredients,
    required this.analyzedInstructions,
    this.nutrition,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'].toString(),
      title: json['title'] ?? 'No Title',
      image: json['image'] ?? '',
      summary: _cleanSummary(json['summary'] ?? ''),
      readyInMinutes: json['readyInMinutes'] ?? 0,
      extendedIngredients: (json['extendedIngredients'] as List? ?? [])
          .map((ingredient) => Ingredient.fromJson(ingredient))
          .toList(),
      analyzedInstructions: (json['analyzedInstructions'] as List? ?? [])
          .map((instruction) => AnalyzedInstruction.fromJson(instruction))
          .toList(),
      nutrition: json['nutrition'] != null 
          ? Nutrition.fromJson(json['nutrition'])
          : null,
    );
  }

  static String _cleanSummary(String summary) {
    return summary.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'summary': summary,
      'readyInMinutes': readyInMinutes,
      'extendedIngredients': extendedIngredients.map((ingredient) => {
        'original': ingredient.original,
        'amount': ingredient.amount,
        'unit': ingredient.unit,
      }).toList(),
      'analyzedInstructions': analyzedInstructions.map((instruction) => {
        'name': instruction.name,
        'steps': instruction.steps.map((step) => {
          'number': step.number,
          'step': step.step,
        }).toList(),
      }).toList(),
    };
  }
}

class Ingredient {
  final String original;
  final double amount;
  final String unit;

  Ingredient({
    required this.original,
    required this.amount,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      original: json['original'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}

class AnalyzedInstruction {
  final String name;
  final List<RecipeStep> steps;

  AnalyzedInstruction({
    required this.name,
    required this.steps,
  });

  factory AnalyzedInstruction.fromJson(Map<String, dynamic> json) {
    return AnalyzedInstruction(
      name: json['name'] ?? '',
      steps: (json['steps'] as List? ?? [])
          .map((step) => RecipeStep.fromJson(step))
          .toList(),
    );
  }
}

// Renamed from Step to RecipeStep to avoid conflict
class RecipeStep {
  final int number;
  final String step;

  RecipeStep({
    required this.number,
    required this.step,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      number: json['number'] ?? 0,
      step: json['step'] ?? '',
    );
  }
}

class Nutrition {
  final List<Nutrient> nutrients;

  Nutrition({required this.nutrients});

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      nutrients: (json['nutrients'] as List? ?? [])
          .map((nutrient) => Nutrient.fromJson(nutrient))
          .toList(),
    );
  }
}

class Nutrient {
  final String name;
  final double amount;
  final String unit;

  Nutrient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}