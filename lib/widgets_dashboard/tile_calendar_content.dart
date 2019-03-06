import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';

class TileCalendarContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double adjustedFontSize = MediaQuery.of(context).size.width * 0.057;
    double adjustedSubFontSize = MediaQuery.of(context).size.width * 0.032;

    return Padding(
      padding: EdgeInsets.only(left: 32.0),
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.today, color: Colors.white, size: 32.0),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Event Calendar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: adjustedFontSize)),
                Text("Find Events Near You", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: adjustedSubFontSize)),
              ],
            ),
          )
        ],
      ),
    );
  }
}