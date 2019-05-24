import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_data_streams/stream_nearby_users.dart';


class TileNearbyUsersContent extends StatelessWidget {

  final WebblenUser currentUser;
  final double lat;
  final double lon;
  TileNearbyUsersContent({this.lat, this.lon, this.currentUser});



  @override
  Widget build(BuildContext context) {
    return Column (
      mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Fonts().textW400('Community Activity', 12.0, FlatColors.darkGray, TextAlign.start),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: StreamNumberOfNearbyUsers(lat: lat, lon: lon)
          ),
          SizedBox(height: 8.0),
          StreamTop10NearbyUsers(currentUser: currentUser, lat: lat, lon: lon)
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
          Fonts().textW500("No Nearby Users Found", 24.0, FlatColors.darkGray, TextAlign.center),
        ],
      ),
    );
  }
}
