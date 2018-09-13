import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_common/common_progress.dart';


class WalletHead extends StatelessWidget {

  final double eventPoints;
  final double impactPoints;
  final VoidCallback powerUpAction;

  WalletHead({this.eventPoints, this.impactPoints, this.powerUpAction});

  Widget _buildEventPointsRow() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Hero(
          tag: 'event-point-stats',
          child: Row(
              children: <Widget>[
                new Container(width: 16.0),
                new Icon(Icons.star, size: 30.0, color: FlatColors.vibrantYellow,),
                new Container(width: 24.0),
                new Text(eventPoints.toStringAsFixed(2), style: Fonts.walletHeadTextStyle),
              ]
          ),
        ),
      ],
    );
  }

  Widget _buildImpactPointsRow() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Hero(
          tag: 'impact-point-stats',
          child: Row(
              children: <Widget>[
                new Container(width: 16.0),
                new Icon(FontAwesomeIcons.bolt, size: 30.0, color: FlatColors.blueGray,),
                new Container(width: 24.0),
                new Text(impactPoints.toStringAsFixed(2), style: Fonts.walletHeadTextStyle),
              ]
          ),
        ),
      ],
    );
  }

  Widget powerUpButton() {
    return impactPoints < 0.1
        ? Material(
          borderRadius: BorderRadius.circular(30.0),
          elevation: 2.0,
          color: FlatColors.londonSquare,
          child: MaterialButton(
            height: 60.0,
            onPressed: null,
            child: Text("Power Unavailable", style: Fonts.subHeadTextStyleWhite),
          ),
        )
      : Material(
        borderRadius: BorderRadius.circular(30.0),
        elevation: 2.0,
        color: FlatColors.greenTeal,
        child: MaterialButton(
          height: 60.0,
          onPressed: powerUpAction,
          child: Text("Power Up", style: Fonts.subHeadTextStyleWhite),
        ),
    );
  }

    @override
    Widget build(BuildContext context) {

      const headerHeight = 150.0;

      return new Container(
        height: headerHeight,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildEventPointsRow(),
                    SizedBox(height: 20.0),
                    _buildImpactPointsRow(),
                  ],
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    powerUpButton()
                  ],
                ),
              ],
            )
          ],
        ),
      );
  }



}
