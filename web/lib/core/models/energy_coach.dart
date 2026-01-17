class EnergyCoachTip {
  final String title;
  final String content;
  final String impactLevel;
  final String category;

  EnergyCoachTip({
    required this.title,
    required this.content,
    required this.impactLevel,
    required this.category,
  });

  factory EnergyCoachTip.fromJson(Map<String, dynamic> json) {
    return EnergyCoachTip(
      title: json['title'],
      content: json['content'],
      impactLevel: json['impact_level'],
      category: json['category'],
    );
  }
}

class EnergyCoachResponse {
  final String summary;
  final List<EnergyCoachTip> tips;
  final int score;
  final DateTime analysisDate;

  EnergyCoachResponse({
    required this.summary,
    required this.tips,
    required this.score,
    required this.analysisDate,
  });

  factory EnergyCoachResponse.fromJson(Map<String, dynamic> json) {
    return EnergyCoachResponse(
      summary: json['summary'],
      tips: (json['tips'] as List).map((t) => EnergyCoachTip.fromJson(t)).toList(),
      score: json['score'] ?? 0,
      analysisDate: DateTime.parse(json['analysis_date']),
    );
  }
}
