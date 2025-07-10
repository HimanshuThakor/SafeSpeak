class ToxicityResponse {
  final bool toxic;
  final double score;

  ToxicityResponse({
    required this.toxic,
    required this.score,
  });

  factory ToxicityResponse.fromJson(Map<String, dynamic> json) {
    return ToxicityResponse(
      toxic: json['toxic'] as bool,
      score: (json['score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'toxic': toxic,
      'score': score,
    };
  }
}
