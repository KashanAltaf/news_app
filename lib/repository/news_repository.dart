import 'dart:convert';

import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/res/app_url/app_url.dart';

class NewsRepository{
  Future<NewsChannelHeadlineModel> fetchNewsChannelHeadlineApi(String source) async {
    String url = AppUrl.headlineUrl(source);
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelHeadlineModel.fromJson(body);
    }
    else{
      throw Exception('Error');
    }
  }
}