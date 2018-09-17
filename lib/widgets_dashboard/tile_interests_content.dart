import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';

class TileInterestsContent extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'interests-red',
              child: Material (
                  color: FlatColors.redOrange,
                  shape: CircleBorder(),
                  child: Padding (
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.favorite, color: Colors.white, size: 30.0),
                  )
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 16.0)),
            Text('Interests', style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w700, fontSize: 20.0)),
            Text("What Interests You?", style: Fonts.subHeaderTextStyle2),
          ]
      ),
    );
  }
}