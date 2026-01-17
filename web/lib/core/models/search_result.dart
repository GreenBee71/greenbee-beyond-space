class SearchResult {
  final int id;
  final String title;
  final String content;
  final String category;
  final double score;

  SearchResult({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.score,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      title: json['title'],
      content: json['content'] ?? "",
      category: json['category'],
      score: (json['score'] as num).toDouble(),
    );
  }
}
