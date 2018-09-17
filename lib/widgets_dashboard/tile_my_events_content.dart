import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';

class TileMyEventsContent extends StatelessWidget {

  final int eventCount;
  TileMyEventsContent({this.eventCount});

  @override
  Widget build(BuildContext context) {
    return Padding (
      padding: const EdgeInsets.all(24.0),
      child: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Column (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Text('My Events', style: TextStyle(color: FlatColors.londonSquare)),
                eventCount == null ? new Text("Loading")//CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
                    :Text('$eventCount', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
              ],
            ),
            Hero(
              tag: 'my-event-purple',
              child: Material(
                  color: FlatColors.exodusPurple,
                  shape: CircleBorder(),
                  child: Padding (
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.date_range, color: Colors.white, size: 30.0),
                  )
              ),
            ),
          ]
      ),
    );
  }
}