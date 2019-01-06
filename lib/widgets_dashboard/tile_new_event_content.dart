import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';

class TileNewEventContent extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    double adjustedFontSize = MediaQuery.of(context).size.width * 0.057;
    double adjustedSubFontSize = MediaQuery.of(context).size.width * 0.026;

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
            Text('New Event', style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w700, fontSize: adjustedFontSize)),
            Text("Create an Event for Your Community", style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w400, fontSize: adjustedSubFontSize)),
          ]
      ),
    );
  }
}