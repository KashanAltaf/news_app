class AppUrl{
  static const _apiKey = '6a970b0290064b2b977054792efac715';
  static const _baseHeadlineUrl = 'https://newsapi.org/v2/top-headlines';

  /// Returns the top-headlines URL for the given [source] id (e.g. bbc-news, cnn).
  static String headlineUrl(String source) =>
      '$_baseHeadlineUrl?sources=$source&apiKey=$_apiKey';
}