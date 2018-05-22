class Topic {
  String name;
  List<Article> articles;

  Topic.fromMap(Map<String, dynamic> map) {
    name = map.keys.toList()[0];
    articles = (map[name] as List).map((art) {
      return new Article.fromMap(art);
    }).toList();
  }
}

class Article {
  final String title;
  final String url;
  final List tags;
  final String provider;
  final String description;

  Article({
    this.title,
    this.url,
    this.tags,
    this.provider,
    this.description
  });

  Article.fromMap(Map<String, dynamic> map)
    : title = map['title'] ?? 'unknown',
      url = map['url'] ?? 'unknown',
      tags = map['tags'] ?? [],
      provider = map['provider'] ?? '',
      description = map['description'] ?? '';
}
