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
          new Container(width: 1.0),
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

class StatsImpactButton  extends StatelessWidget {

  final String impactPoints;
  final VoidCallback impactPointsAction;
  StatsImpactButton({this.impactPoints, this.impactPointsAction});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.5,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: impactPointsAction,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
              children: <Widget>[
                new Icon(FontAwesomeIcons.bolt, size: 20.0, color: FlatColors.blueGray),
                new Container(width: 8.0),
                new Text(impactPoints, style: Fonts.pointStatStyle),
              ]
          ),
        ),
      ),
    );
  }
}

class StatsImpactMin extends StatelessWidget {

  final String impactPoints;
  StatsImpactMin(this.impactPoints);

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Icon(FontAwesomeIcons.bolt, size: 14.0, color: FlatColors.blueGray),
          new Container(width: 2.0),
          new Text(impactPoints, style: Fonts.pointStatStyleSmall),
        ]
    );
  }
}