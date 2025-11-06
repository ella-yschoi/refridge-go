class CookingTool {
  final String name;
  final String icon;

  const CookingTool({
    required this.name,
    required this.icon,
  });
}

enum Difficulty {
  easy('Easy', 'Easy recipes for beginners'),
  medium('Medium', 'Moderate recipes with some technique'),
  hard('Hard', 'Advanced recipes requiring skill');

  final String label;
  final String description;

  const Difficulty(this.label, this.description);
}
