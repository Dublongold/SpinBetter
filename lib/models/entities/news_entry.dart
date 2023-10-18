import 'sport_entry.dart';

class NewsEntry implements SportEntry {
  const NewsEntry({
    required this.newsImageUrl,
    required this.newsText,
    required this.newsLink
  });

  final String newsImageUrl;
  final String newsText;
  final String newsLink;
}