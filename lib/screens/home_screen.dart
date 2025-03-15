import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/news_service.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';
import '../widgets/category_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  late Future<List<News>> _newsFuture;
  final ScrollController _scrollController = ScrollController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() {
    setState(() {
      _newsFuture = _newsService.fetchNews(category: selectedCategory);
    });
  }

  final List<String> categories = [
    'Technology',
    'Business',
    'Sports',
    'Health',
    'Science',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Today\'s News',
          style: GoogleFonts.lato(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 100),
              // Glassmorphism Category Tiles
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                      category: categories[index],
                      isSelected: selectedCategory == categories[index],
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index];
                          _fetchNews();
                        });
                      },
                    );
                  },
                ),
              ),
              // News List
              Expanded(
                child: FutureBuilder<List<News>>(
                  future: _newsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No news available',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      );
                    } else {
                      final newsList = snapshot.data!;
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          return NewsCard(news: newsList[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.arrow_upward, color: Colors.blueAccent),
      ),
    );
  }
}
