import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';

class EventSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 8.0),
        height: 2.0,
        width: 200.0,
        color: FlatColors.spiroDiscoBallBlue
    );
  }
}

class SubEventSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 4.0),
        height: 1.0,
        width: 45.0,
        color: Colors.white70
    );
  }
}