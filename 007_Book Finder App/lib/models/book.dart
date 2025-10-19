class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? thumbnail;
  final String? description;
  final int? pageCount;
  final String? publishedDate;
  final List<String>? categories;
  final double? averageRating;
  final int? ratingsCount;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.thumbnail,
    this.description,
    this.pageCount,
    this.publishedDate,
    this.categories,
    this.averageRating,
    this.ratingsCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    
    // Handle thumbnail URL - replace http with https if needed
    String? thumbnail = imageLinks['thumbnail'] ?? imageLinks['smallThumbnail'];
    if (thumbnail != null && thumbnail.startsWith('http:')) {
      thumbnail = thumbnail.replaceFirst('http:', 'https:');
    }
    
    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title']?.toString() ?? 'Unknown Title',
      authors: _parseAuthors(volumeInfo['authors']),
      thumbnail: thumbnail,
      description: volumeInfo['description']?.toString(),
      pageCount: volumeInfo['pageCount'] is int ? volumeInfo['pageCount'] : null,
      publishedDate: volumeInfo['publishedDate']?.toString(),
      categories: _parseCategories(volumeInfo['categories']),
      averageRating: volumeInfo['averageRating'] is num ? volumeInfo['averageRating'].toDouble() : null,
      ratingsCount: volumeInfo['ratingsCount'] is int ? volumeInfo['ratingsCount'] : null,
    );
  }

  static List<String> _parseAuthors(dynamic authors) {
    if (authors is List) {
      return authors.map((a) => a.toString()).toList();
    }
    return ['Unknown Author'];
  }

  static List<String>? _parseCategories(dynamic categories) {
    if (categories is List) {
      return categories.map((c) => c.toString()).toList();
    }
    return null;
  }
}