import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';

class StatsImpact extends StatelessWidget {

  final String impactPoints;
  StatsImpact(this.impactPoints);

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Icon(FontAwesomeIcons.bolt, size: 20.0, color: FlatColors.blueGray),
          new Container(width: 8.0),
          new Text(impactPoints, style: Fonts.pointStatStyle),
        ]
    );
  }
}

class StatsImpactLarge extends StatelessWidget {

  final String impactPoints;
  StatsImpactLarge(this.impactPoints);

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Icon(FontAwesomeIcons.bolt, size: 30.0, color: FlatColors.blueGray),
          new Container(width: 8.0),
          new Text(impactPoints, style: Fonts.pointStatStyleLarge),
        ]
    );
  }
}