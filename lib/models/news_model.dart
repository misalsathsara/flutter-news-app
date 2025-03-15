class News {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;

  News({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
      publishedAt: json['published'] ?? 'Unknown Date',
    );
  }
}
