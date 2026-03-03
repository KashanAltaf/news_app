import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:news_app/controller/news_controller.dart';
import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {bbcNews, aryNews, independent, ign, cnn, alJazeera}

class _HomeScreenState extends State<HomeScreen> {
  FilterList? selectedMenu;
  String selectedOutlet = 'bbc-news';
  Future<NewsChannelHeadlineModel>? _headlinesFuture;
  bool _futureInitialized = false;

  void _onOutletSelected(FilterList item, NewsController controller) {
    String name = selectedOutlet;
    if (item == FilterList.bbcNews) {
      name = 'bbc-news';
    } else if (item == FilterList.aryNews) {
      name = 'ary-news';
    } else if (item == FilterList.independent) {
      name = 'independent';
    } else if (item == FilterList.cnn) {
      name = 'cnn';
    } else if (item == FilterList.alJazeera) {
      name = 'al-jazeera-english';
    } else if (item == FilterList.ign) {
      name = 'ign';
    }
    setState(() {
      selectedMenu = item;
      selectedOutlet = name;
      _headlinesFuture = controller.fetchNewsChannelHeadlineApi(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height * 1;
    final width = Get.width * 1;
    final NewsController controller = Get.put(NewsController());
    final format = DateFormat("MMMM dd, yyyy");
    if (!_futureInitialized) {
      _headlinesFuture = controller.fetchNewsChannelHeadlineApi(selectedOutlet);
      _futureInitialized = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset(
            'images/category_icon.png',
            fit: BoxFit.cover,
            height: 30,
            width: 30,
          ),
        ),
        actions: [
          PopupMenuButton(
            initialValue: selectedMenu,
              icon: Icon(Icons.more_vert, color: Colors.black,),
              onSelected: (FilterList item) => _onOutletSelected(item, controller),
              itemBuilder: (context) => <PopupMenuEntry<FilterList>> [
                PopupMenuItem<FilterList>(
                  value: FilterList.bbcNews,
                  child: Text('BBC News'),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.aryNews,
                  child: Text('ARY News'),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.cnn,
                  child: Text('CNN'),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.ign,
                  child: Text('IGN'),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.independent,
                  child: Text('Independent'),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.alJazeera,
                  child: Text('Al-Jazeera'),
                ),
              ]
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder(
              future: _headlinesFuture,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitSpinningLines(size: 50, color: Colors.blue),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles[index].publishedAt.toString());
                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: height * 0.6,
                              width: width * 0.9,
                              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles[index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      SpinKitFadingCircle(
                                        color: Colors.blue,
                                        size: 50,
                                      ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.all(15),
                                  height: height * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width * 0.7,
                                        child: Text(
                                          snapshot.data!.articles[index].title.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 17),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: width * 0.7,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles[index].source.name.toString(),
                                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blue),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
