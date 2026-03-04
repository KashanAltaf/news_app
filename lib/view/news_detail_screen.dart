import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  NewsDetailScreen({super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final title = Get.arguments?['title'];
    final url = Get.arguments?['url'];
    final content = Get.arguments?['content'];
    final source = Get.arguments?['source'];
    final publishedAt = Get.arguments?['publishedAt'];
    final description = Get.arguments?['description'];
    final author = Get.arguments?['author'];
    final urlToImage = Get.arguments?['urlToImage'];
    final height = Get.height * 1;
    final width = Get.width * 1;
    DateTime dateTime = DateTime.parse(publishedAt.toString());
    DateFormat format = DateFormat('MMMM dd, yyyy');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
              child: CachedNetworkImage(
                  imageUrl: urlToImage.toString(),
                fit: BoxFit.fill,
                placeholder: (context, url) => SpinKitFadingCircle(
                  size: 50,
                  color: Colors.blue,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red,),
              ),
            ),
          ),
          Container(
            height: height * 0.6,
            margin: EdgeInsets.only(top: height * 0.4),
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView(
              children: [
                Text(
                  title.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: height * 0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      source.toString(),
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87
                      ),
                    ),
                    Text(
                      format.format(dateTime),
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03,),
                Text(
                  description.toString(),
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
