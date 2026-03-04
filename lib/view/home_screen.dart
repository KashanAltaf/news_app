import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:news_app/controller/news_controller.dart';
import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:news_app/routes/routes_names.dart';

import '../models/categories_news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {bbcNews, aryNews, independent, ign, cnn, alJazeera}
FilterList? selectedMenu;
String name = 'bbc-news';

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final height = Get.height * 1;
    final width = Get.width * 1;
    final NewsController controller = Get.put(NewsController());
    final format = DateFormat("MMMM dd, yyyy");
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
          onPressed: () {
            Get.toNamed(RoutesName.categoriesScreen);
          },
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
              onSelected: (FilterList item){
                if(FilterList.bbcNews.name == item.name){
                  name = 'bbc-news';
                }
                if(FilterList.aryNews.name == item.name){
                  name = 'ary-news';
                }
                if(FilterList.independent.name == item.name){
                  name = 'independent';
                }
                if(FilterList.cnn.name == item.name){
                  name = 'cnn';
                }
                if(FilterList.alJazeera.name == item.name){
                  name = 'al-jazeera-english';
                }
                if(FilterList.ign.name == item.name){
                  name = 'ign';
                }
                setState(() {
                  selectedMenu = item;
                });
              },
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
              future: controller.fetchNewChannelHeadlinesApi(name),

              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitSpinningLines(size: 50, color: Colors.blue),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles.length,
                    shrinkWrap: true,
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<CategoriesNewsModel>(
                future: controller.fetchCategoriesNewsApi('General'),
                builder: (BuildContext context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  }
                  else{
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    height: height * 0.18,
                                    width: width * 0.3,
                                    placeholder: (context, url) => Container(
                                      child: Center(
                                        child: SpinKitCircle(
                                          size: 50,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red,),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                      height: height * 0.18,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index].title.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    snapshot.data!.articles![index].source!.name.toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    format.format(dateTime),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
            ),
          ),
        ],
      ),
    );
  }
}
