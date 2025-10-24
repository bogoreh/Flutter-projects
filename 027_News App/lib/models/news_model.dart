class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String source;
  final String author;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
    required this.author,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? 
          'https://via.placeholder.com/400x200/3B82F6/FFFFFF?text=No+Image',
      publishedAt: json['publishedAt'] ?? '',
      source: json['source']['name'] ?? 'Unknown Source',
      author: json['author'] ?? 'Unknown Author',
    );
  }
}