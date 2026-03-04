import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/res/app_url/app_url.dart';

class NewsRepository{
  Future<NewsChannelHeadlineModel> fetchNewChannelHeadlinesApi(String channelName)async{
    String url = 'https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=6a970b0290064b2b977054792efac715' ;
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelHeadlineModel.fromJson(body);
    }
    else {
      throw Exception('Error');
    }
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String categoryName)async{
    String url = 'https://newsapi.org/v2/everything?q=$categoryName&apiKey=6a970b0290064b2b977054792efac715' ;
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    else {
      throw Exception('Error');
    }
  }
}