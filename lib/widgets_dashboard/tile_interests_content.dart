import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';

class TileCalendarContent extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'event-blue',
              child: Material(
                  color: FlatColors.electronBlue,
                  shape: CircleBorder(),
                  child: Padding (
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.today, color: Colors.white, size: 30.0),
                  )
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 16.0)),
            Text('Calendar', style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w700, fontSize: 24.0)),
            Text("Event Calendar", style: Fonts.subHeaderTextStyle),
          ]
      ),
    );
  }
}