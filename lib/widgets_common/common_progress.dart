import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';

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

  final double containerHeight;
  final double containerWidth;
  final double progressHeight;
  final double progressWidth;
  final Color progressColor;

  CustomCircleProgress(this.containerHeight, this.containerWidth, this.progressHeight, this.progressWidth, this.progressColor);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          accentColor: progressColor
      ),
      child: Container(
        height: containerHeight,
        width: containerWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: progressHeight,
              width: progressWidth,
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
      content: CustomCircleProgress(60.0, 60.0, 30.0, 30.0, Colors.grey),
    );
  }
}

class LoadingScreenProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40.0,
            width: 40.0,
            child: CircularProgressIndicator(backgroundColor: FlatColors.darkGray),
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 240.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: LoadingScreenProgressIndicator(),//_buildLoadingIndicator(),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}