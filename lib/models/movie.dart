class Movie {
  final String id;
  final String title;
  final String category;
  final int? rating;
  final String comment;
  final String? imagePath;
  final DateTime dateAdded;

  Movie({
    required this.id,
    required this.title,
    required this.category,
    this.rating,
    required this.comment,
    this.imagePath,
    DateTime? dateAdded,
  }) : this.dateAdded = dateAdded ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'rating': rating,
      'comment': comment,
      'imagePath': imagePath,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  static Movie fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      rating: map['rating'],
      comment: map['comment'],
      imagePath: map['imagePath'],
      dateAdded: DateTime.parse(map['dateAdded'] ?? DateTime.now().toIso8601String()),
    );
  }
} 