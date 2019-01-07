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
          new Container(width: 4.0),
          new Text(eventHistoryCount, style: Fonts.pointStatStyle),
        ]
    );
  }
}

class StatsEventHistoryCountButton  extends StatelessWidget {

  final String eventHistoryCount;
  final VoidCallback viewHistoryAction;
  StatsEventHistoryCountButton({this.eventHistoryCount, this.viewHistoryAction});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.5,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: viewHistoryAction,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
              children: <Widget>[
                new Icon(FontAwesomeIcons.calendarAlt, size: 20.0, color: FlatColors.electronBlue),
                new Container(width: 8.0),
                new Text(eventHistoryCount, style: Fonts.pointStatStyle),
              ]
          ),
        ),
      ),
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

class StatsEventHistoryCountMin extends StatelessWidget {

  final String eventHistoryCount;
  StatsEventHistoryCountMin(this.eventHistoryCount);

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          new Icon(FontAwesomeIcons.calendarAlt, size: 16.0, color: FlatColors.electronBlue),
          new Container(width: 3.0),
          new Text(eventHistoryCount, style: Fonts.pointStatStyleSmall),
        ]
    );
  }
}