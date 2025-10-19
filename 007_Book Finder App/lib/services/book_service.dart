import 'dart:convert';
import 'dart:io';
import '../models/book.dart';

class BookService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  
  static Future<List<Book>> searchBooks(String query, {int maxResults = 20}) async {
    try {
      final HttpClient client = HttpClient();
      final HttpClientRequest request = await client.getUrl(
        Uri.parse('$_baseUrl?q=$query&maxResults=$maxResults')
      );
      final HttpClientResponse response = await request.close();
      
      if (response.statusCode == 200) {
        final String responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);
        final items = data['items'] as List?;
        
        if (items == null) return [];
        
        return items.map((item) => Book.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }
}