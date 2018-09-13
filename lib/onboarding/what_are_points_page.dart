import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_guide/guide_text.dart';



class WhatArePointsPage extends StatelessWidget {


  // ** APP BAR
  final appBar = AppBar(
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('Points', style: Fonts.dashboardTitleStyle),
    leading: BackButton(color: FlatColors.londonSquare),
  );

  Widget guideHeaderText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Text(text, style: Fonts.guideHeaderTextStyle, textAlign: TextAlign.center),
    );
  }


  Widget guideBodyText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: Text(text, style: Fonts.guideBodyTextStyle, textAlign: TextAlign.center),
    );
  }


  @override
  Widget build(BuildContext context) {
    final body = Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 24.0),
          GuideHeaderText("Points!"),
          SizedBox(height: 16.0),
          Image.asset('assets/images/star.png', height: 140.0, width: 140.0),
          SizedBox(height: 16.0),
          GuideBodyText("Points are what are rewarded to users for attending events within their community. Points can be used to redeem rewards, increase your impact, increase your rank, and more."),
          SizedBox(height: 24.0),
          GuideHeaderText("When do I Get Points?"),
          SizedBox(height: 16.0),
          Image.asset('assets/images/reward_points.png', height: 140.0, width: 140.0),
          SizedBox(height: 16.0),
          GuideBodyText("After an event you've checked into is over, all users that attended will receive points. The amount you received depends on your impact and the amount of users that checked into the same event"),
          SizedBox(height: 24.0),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}