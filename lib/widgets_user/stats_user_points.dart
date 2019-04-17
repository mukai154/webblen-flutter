import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';

class StatsUserPoints extends StatelessWidget {

  final String userPoints;
  final Color textColor;
  final double textSize;
  final double iconSize;
  final VoidCallback onTap;
  final bool darkLogo;
  StatsUserPoints({this.userPoints, this.textColor, this.textSize, this.iconSize, this.onTap, this.darkLogo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
          children: <Widget>[
            darkLogo
                ? Image.asset('assets/images/webblen_coin_small_dark.png', height: iconSize, width: iconSize, fit: BoxFit.contain)
                : Image.asset('assets/images/webblen_coin_small_red.png', height: iconSize, width: iconSize, fit: BoxFit.contain),
            Container(width: 3.0),
            Fonts().textW500(userPoints, textSize, textColor, TextAlign.center)
          ]
      ),
    );
  }
}

class StatsUserPointsMin extends StatelessWidget {

  final String userPoints;
  final Color textColor;
  final double textSize;
  final double iconSize;
  final VoidCallback onTap;
  StatsUserPointsMin({this.userPoints, this.textColor, this.textSize, this.iconSize, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
          children: <Widget>[
            Image.asset('assets/images/webblen_logo.png', height: iconSize, width: iconSize, fit: BoxFit.contain),
            Container(width: 4.0),
            Fonts().textW500(userPoints, textSize, textColor, TextAlign.center)
          ]
      ),
    );
  }
}
