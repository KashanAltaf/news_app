import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsController{
  final _repo = NewsRepository();

  Future<NewsChannelHeadlineModel> fetchNewChannelHeadlinesApi(String channelName) async{
    final response = await _repo.fetchNewChannelHeadlinesApi(channelName);
    return response ;
  }
}