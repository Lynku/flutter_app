class Meal {
  final String id;
  final String title;
  final String imageUrl;
  final int calories;
  final String vitamins;
  final String proteins;
  final List<String> items;
  final String preparation;

  const Meal({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.calories,
    required this.vitamins,
    required this.proteins,
    required this.items,
    required this.preparation,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      calories: json['calories'],
      vitamins: json['vitamins'],
      proteins: json['proteins'],
      items: List<String>.from(json['items']),
      preparation: json['preparation'],
    );
  }
}