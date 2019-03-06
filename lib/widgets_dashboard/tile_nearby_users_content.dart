import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:webblen/styles/fonts.dart';


class TileNearbyUsersContent extends StatelessWidget {

  final int activeUserCount;
  final List<Widget> top10NearbyUsers;
  TileNearbyUsersContent({this.activeUserCount, this.top10NearbyUsers});


  Widget buildTop10Users(BuildContext context){

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          //margin: EdgeInsets.symmetric(horizontal: 12.0),
          height: 122.0,
          width: MediaQuery.of(context).size.width * 0.957,
          child: Center(
            child: new CarouselSlider(
              items: top10NearbyUsers,
              height: 150.0,
              autoPlay: true,
              autoPlayDuration: Duration(seconds: 10),
              autoPlayCurve: Curves.linear,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column (
      mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Fonts().textW400('Community Activity', 12.0, Colors.white, TextAlign.start),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: activeUserCount == null ?  Container() : Fonts().textW700('$activeUserCount Nearby Users', 18.0, Colors.white, TextAlign.start),
          ),
          top10NearbyUsers == null
              ? CustomCircleProgress(100.0, 100.0, 30.0, 30.0, FlatColors.londonSquare)
              :buildTop10Users(context),
        ],
      );
  }
}

class TileNoNearbyUsersContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 70.0,
            width: 70.0,
            child: new Image.asset("assets/images/sleepy.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          new Text("No Nearby Users Found", style: Fonts.noEventsFont, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
