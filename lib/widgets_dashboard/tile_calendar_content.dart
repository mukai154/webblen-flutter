import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';

class TileCalendarContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.only(left: 30.0),
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.today, color: FlatColors.darkGray, size: 32.0),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Fonts().textW800('Event Calendar', 22.0, FlatColors.darkGray, TextAlign.left),
                Fonts().textW500(' Find Events Near You', 12.0, FlatColors.lightAmericanGray, TextAlign.left),
              ],
            ),
          )
        ],
      ),
    );
  }
}