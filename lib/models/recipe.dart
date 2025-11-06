class Recipe {
  final String menu;
  final String description;
  final List<String> steps;

  Recipe({
    required this.menu,
    required this.description,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      menu: json['menu'] as String? ?? 'Unknown Menu',
      description: json['description'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu': menu,
      'description': description,
      'steps': steps,
    };
  }
}

