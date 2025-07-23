class Blog {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;

  Blog({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.date,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      date: DateTime.parse(json['date']),
    );
  }
}
