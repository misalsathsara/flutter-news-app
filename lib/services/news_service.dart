import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  final String baseUrl = 'api.currentsapi.services';
  final String apiKey = 'a4ZoKoeS4UJ99EsvrOcVx6wYF56cZ69FRRKr_bsVl5-3RZl8';

  Future<List<News>> fetchNews({String? category}) async {
    final queryParameters = {
      'language': 'en',
      if (category != null) 'category': category.toLowerCase(), // Add category filter
    };

    final uri = Uri.https(baseUrl, '/v1/latest-news', queryParameters);
    final headers = {'Authorization': apiKey};

    print('Request URL: $uri'); // Debugging
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> articles = data['news'] ?? [];
      print('Fetched ${articles.length} articles for category: $category'); // Debugging
      return articles.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
