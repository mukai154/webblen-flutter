import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';

class TileNewEventContent extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'new-event-yellow',
              child: Material(
                  color: FlatColors.vibrantYellow,
                  shape: CircleBorder(),
                  child: Padding (
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.add_circle, color: Colors.white, size: 30.0),
                  )
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 16.0)),
            Text('New Event', style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w700, fontSize: 20.0)),
            Text("Create an Event for Your Community", style: Fonts.subHeaderTextStyle2),
          ]
      ),
    );
  }
}