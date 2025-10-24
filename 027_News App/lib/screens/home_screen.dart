import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/loading_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  late Future<List<NewsArticle>> _newsFuture;
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Technology',
    'Science',
    'Business'
  ];

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsService.fetchTopHeadlines();
  }

  void _filterNewsByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _refreshNews() {
    setState(() {
      _newsFuture = _newsService.fetchTopHeadlines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNews,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                return CategoryChip(
                  label: category,
                  isSelected: _selectedCategory == category,
                  onTap: () => _filterNewsByCategory(category),
                );
              }).toList(),
            ),
          ),
          // News List
          Expanded(
            child: FutureBuilder<List<NewsArticle>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingShimmer();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load news',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshNews,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                final articles = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: () async {
                    _refreshNews();
                  },
                  child: ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return NewsCard(article: article);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}