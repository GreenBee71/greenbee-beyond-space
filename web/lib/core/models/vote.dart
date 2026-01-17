class Vote {
  final int id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final bool isActive;
  final List<String> options;
  final Map<String, dynamic> results;

  Vote({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.options,
    required this.results,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      isActive: json['is_active'] ?? true,
      options: List<String>.from(json['options'] ?? []),
      results: Map<String, dynamic>.from(json['results'] ?? {}),
    );
  }
}
