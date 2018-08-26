import 'package:flutter/material.dart';
import 'package:webblen/styles/gradients.dart';

class GradientAppBar extends StatelessWidget {
  final String title;
  final LinearGradient gradient;
  final double barHeight = 55.0;
  final Color textColor;


  GradientAppBar(this.title, this.gradient, this.textColor);

  @override
  Widget build(BuildContext context) {

    // ** STATUS BAR
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    final barText = Text(title,
        style: new TextStyle(
          fontSize: 21.0,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
    );

    final backBtn = BackButton(color: Colors.white);


    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: barHeight + statusBarHeight,
      decoration: new BoxDecoration(
        gradient: gradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          backBtn,
          barText,
          SizedBox(width: 50.0),
        ],
      ),
    );
  }
}

