class Ingredient {
  final String name;
  final bool isSelected;

  Ingredient({
    required this.name,
    this.isSelected = false,
  });

  Ingredient copyWith({String? name, bool? isSelected}) {
    return Ingredient(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

