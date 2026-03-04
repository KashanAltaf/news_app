import 'package:flutter/material.dart';
import 'package:news_app/controller/news_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  final NewsController controller = Get.put(NewsController());
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = 'general';
  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context){
    final width = Get.width * 1;
    final height = Get.height * 1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: categoriesList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 12 : 0, right: 12.0,),
                  child: InkWell(
                    onTap: (){
                      categoryName = categoriesList[index].toLowerCase();
                      setState(() {

                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: categoryName == categoriesList[index].toLowerCase() ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                            child: Text(
                              categoriesList[index].toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white
                              ),
                            ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
                future: controller.fetchCategoriesNewsApi(categoryName),
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
                   return ListView.builder(
                     itemCount: snapshot.data!.articles!.length,
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
                                       ),
                                       Spacer(),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text(
                                             snapshot.data!.articles![index].source!.name.toString(),
                                             style: GoogleFonts.poppins(
                                               fontSize: 14,
                                               color: Colors.blue,
                                               fontWeight: FontWeight.w600,
                                             ),
                                           ),
                                           Text(
                                             format.format(dateTime),
                                             style: GoogleFonts.poppins(
                                               fontSize: 15,
                                               color: Colors.black54,
                                               fontWeight: FontWeight.w500,
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
