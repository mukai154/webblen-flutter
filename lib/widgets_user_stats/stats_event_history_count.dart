import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';

class StatsEventHistoryCount extends StatelessWidget {

  final String eventHistoryCount;
  StatsEventHistoryCount(this.eventHistoryCount);

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Icon(FontAwesomeIcons.calendarAlt, size: 20.0, color: FlatColors.electronBlue),
          new Container(width: 8.0),
          new Text(eventHistoryCount, style: Fonts.pointStatStyle),
        ]
    );
  }
}

class StatsEventHistoryCountLarge extends StatelessWidget {

  final String eventHistoryCount;
  StatsEventHistoryCountLarge(this.eventHistoryCount);

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Icon(FontAwesomeIcons.calendarAlt, size: 30.0, color: FlatColors.electronBlue),
          new Container(width: 8.0),
          new Text(eventHistoryCount, style: Fonts.pointStatStyleLarge),
        ]
    );
  }
}