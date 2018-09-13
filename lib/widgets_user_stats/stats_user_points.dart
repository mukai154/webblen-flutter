import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';

class StatsUserPoints extends StatelessWidget {

  final String userPoints;
  StatsUserPoints(this.userPoints);

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Icon(Icons.star, size: 18.0, color: FlatColors.vibrantYellow,),
          new Container(width: 8.0),
          new Text(userPoints, style: Fonts.pointStatStyle),
        ]
    );
  }
}