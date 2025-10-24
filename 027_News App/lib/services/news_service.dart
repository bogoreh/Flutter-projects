import '../models/news_model.dart';

class NewsService {
  Future<List<NewsArticle>> fetchTopHeadlines() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    return mockNewsData;
  }

  Future<List<NewsArticle>> fetchNewsByCategory(String category) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockNewsData.where((article) => 
        article.source.toLowerCase().contains(category.toLowerCase())).toList();
  }
}

// Mock data for demonstration
final List<NewsArticle> mockNewsData = [
  NewsArticle(
    title: 'Flutter 3.0 Released with Major Updates',
    description: 'Google announces Flutter 3.0 with improved performance and new features for cross-platform development. Developers can now build for more platforms with better tooling support.',
    url: 'https://example.com',
    urlToImage: 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=400&h=200&fit=crop',
    publishedAt: '2024-01-15T10:30:00Z',
    source: 'Tech News',
    author: 'John Doe',
  ),
  NewsArticle(
    title: 'AI Revolution Transforming Industries',
    description: 'Artificial Intelligence is reshaping how businesses operate across various sectors worldwide. From healthcare to finance, AI solutions are driving innovation.',
    url: 'https://example.com',
    urlToImage: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400&h=200&fit=crop',
    publishedAt: '2024-01-14T15:45:00Z',
    source: 'Technology',
    author: 'Jane Smith',
  ),
  NewsArticle(
    title: 'Sustainable Energy Solutions Gain Momentum',
    description: 'Renewable energy sources are becoming more affordable and accessible globally. Solar and wind power lead the transition to clean energy.',
    url: 'https://example.com',
    urlToImage: 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400&h=200&fit=crop',
    publishedAt: '2024-01-14T09:15:00Z',
    source: 'Environment',
    author: 'Mike Johnson',
  ),
  NewsArticle(
    title: 'Space Exploration Reaches New Milestones',
    description: 'Recent missions are pushing the boundaries of what we know about our universe. New telescopes and spacecraft reveal amazing discoveries.',
    url: 'https://example.com',
    urlToImage: 'https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=400&h=200&fit=crop',
    publishedAt: '2024-01-13T20:00:00Z',
    source: 'Science',
    author: 'Sarah Wilson',
  ),
  NewsArticle(
    title: 'Global Markets Show Positive Trends',
    description: 'Stock markets worldwide demonstrate strong performance as economic recovery continues. Technology and green energy sectors lead the growth.',
    url: 'https://example.com',
    urlToImage: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400&h=200&fit=crop',
    publishedAt: '2024-01-13T14:20:00Z',
    source: 'Business',
    author: 'Robert Brown',
  ),
  NewsArticle(
    title: 'New Breakthrough in Medical Research',
    description: 'Scientists announce significant progress in treating chronic diseases. The new approach shows promising results in clinical trials.',
    url: 'https://example.com',
    urlToImage: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=200&fit=crop',
    publishedAt: '2024-01-12T11:30:00Z',
    source: 'Health',
    author: 'Dr. Emily Chen',
  ),
];