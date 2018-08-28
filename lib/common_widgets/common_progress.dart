import 'package:flutter/material.dart';

class CustomLinearProgress extends StatelessWidget {

  final Color progressBarColor;
  final Color backgroundColor;

  CustomLinearProgress(this.progressBarColor, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        accentColor: progressBarColor,
      ),
      child: Container(
        height: 64.0,
        child: Column(
          children: <Widget>[
            SizedBox(height: 28.0),
            SizedBox(
              height: 2.0,
              child: LinearProgressIndicator(backgroundColor: Colors.transparent),
            ),
            SizedBox(height: 28.0),
          ],
        ),
      ),
    );
  }
}

class CustomCircleProgress extends StatelessWidget {

  final double height;
  final double width;
  final Color progressColor;

  CustomCircleProgress(this.height, this.width, this.progressColor);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          accentColor: progressColor
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: height,
              width: width,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomCircleProgress(30.0, 30.0, Colors.grey),
    );
  }
}