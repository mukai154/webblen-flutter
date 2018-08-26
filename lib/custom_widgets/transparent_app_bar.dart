import 'package:flutter/material.dart';

class TransparentAppBar extends StatelessWidget {
  final String title = "";
  final double barHeight = 66.0;

 // GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {

    // ** STATUS BAR
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: barHeight + statusBarHeight,
      child: new Center(
        child: new Text(
          title,
        ),
      ),
    );
  }
}