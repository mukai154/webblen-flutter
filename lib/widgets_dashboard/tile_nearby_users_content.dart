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
          width: MediaQuery.of(context).size.width * 0.955,
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
        children: <Widget>[
          Row (
            children: <Widget> [
              Column (
                children: <Widget> [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 16.0, 0.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        Text('Community Activity', style: TextStyle(color: FlatColors.londonSquare)),
                        activeUserCount == null ?  Container()//CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
                            : Text('  $activeUserCount Nearby Users', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
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
