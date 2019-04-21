//import 'package:flutter/material.dart';
//import 'package:webblen/models/community_news.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:carousel_slider/carousel_slider.dart';
//import 'package:webblen/styles/flat_colors.dart';
//import 'package:webblen/widgets_common/common_progress.dart';
//import 'package:webblen/styles/fonts.dart';
//
//class TileCommunityNewsContent extends StatelessWidget {
//
//  final List<Widget> newsPosts;
//  TileCommunityNewsContent({this.newsPosts});
//
//
//  Widget buildNewsPosts(BuildContext context){
//
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//          child: Fonts().textW700("LOCAL NEWS", 16.0, FlatColors.londonSquare, TextAlign.left),
//        ),
//        new CarouselSlider(
//          aspectRatio: 4/3,
//          height: MediaQuery.of(context).size.height * 0.36,
//          items: newsPosts,
//          autoPlay: true,
//          autoPlayAnimationDuration: Duration(seconds: 2),
//          autoPlayInterval: Duration(seconds: 7),
//          autoPlayCurve: Curves.linear,
//        ),
//      ],
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Column (
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        newsPosts == null
//            ? CustomLinearProgress(progressBarColor: FlatColors.webblenRed)
//            : buildNewsPosts(context),
//      ],
//    );
//  }
//}
//
//class CommunityNewsRow extends StatelessWidget {
//
//  final CommunityNewsPost newsPost;
//  final bool viewingDetails;
//  final VoidCallback newsAction;
//  final TextStyle headerTextStyle = TextStyle(
//      fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.white);
//  final TextStyle subHeaderTextStyle = TextStyle(
//      fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white);
//  final TextStyle statTextStyle = TextStyle(
//      fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.white);
//
//  CommunityNewsRow({this.newsPost, this.newsAction, this.viewingDetails});
//
//  @override
//  Widget build(BuildContext context) {
//
//    final newsCard = Hero(
//      tag: newsPost.newsImageUrl,
//      child: Container(
//        height: viewingDetails ? MediaQuery.of(context).size.height * 0.39 : MediaQuery.of(context).size.height * 0.33,
//        margin: new EdgeInsets.symmetric(horizontal: 4.0),
//        decoration: new BoxDecoration(
//          image: DecorationImage(
//              image: CachedNetworkImageProvider(newsPost.newsImageUrl),
//              fit: BoxFit.cover),
//          color: Colors.white,
//          shape: BoxShape.rectangle,
//          borderRadius: new BorderRadius.circular(16.0),
//          boxShadow: <BoxShadow>[
//            new BoxShadow(
//              color: Colors.black12,
//              blurRadius: 5.5,
//              offset: Offset(0.0, 5.0),
//            ),
//          ],
//        ),
//      ),
//    );
//
//
//    return new GestureDetector(
//      onTap: newsAction,
//      child: new Container(
//          child: new Stack(
//            children: <Widget>[
//              newsCard,
//            ],
//          ),
//      ),
//    );
//  }
//}