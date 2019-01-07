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
          new Icon(Icons.star, size: 24.0, color: FlatColors.vibrantYellow,),
          new Container(width: 4.0),
          new Text(userPoints, style: Fonts.pointStatStyle),
        ]
    );
  }
}

class StatsUserPointsLarge extends StatelessWidget {

  final String userPoints;
  StatsUserPointsLarge(this.userPoints);

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Icon(Icons.star, size: 34.0, color: FlatColors.vibrantYellow,),
          new Container(width: 4.0),
          new Text(userPoints, style: Fonts.pointStatStyleLarge),
        ]
    );
  }
}

class StatsUserPointsButton  extends StatelessWidget {

  final String userPoints;
  final VoidCallback userPointsAction;
  StatsUserPointsButton({this.userPoints, this.userPointsAction});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.5,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: userPointsAction,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
              children: <Widget>[
                new Icon(FontAwesomeIcons.solidStar, size: 20.0, color: FlatColors.vibrantYellow),
                new Container(width: 8.0),
                new Text(userPoints, style: Fonts.pointStatStyle),
              ]
          ),
        ),
      ),
    );
  }
}

class StatsUserPointsMin extends StatelessWidget {

  final String userPoints;
  StatsUserPointsMin(this.userPoints);

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Icon(Icons.star, size: 16.0, color: FlatColors.vibrantYellow,),
          new Container(width: 4.0),
          new Text(userPoints, style: Fonts.pointStatStyleSmall),
        ]
    );
  }
}