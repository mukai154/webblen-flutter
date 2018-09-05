import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';

/// QuickActions represents the horizontal list of rectangular buttons below the header
class QuickActions extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildAction(
                  "Groups", () {}, FlatColors.londonSquare,
                  new AssetImage("assets/images/padlock.png")),
              _buildAction(
                  "My\nWallet", () {}, FlatColors.londonSquare,
                  new AssetImage("assets/images/padlock.png")),
            ],
          ),
          SizedBox(height: 24.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildAction(
                  "Community\nChallenges", () {}, FlatColors.londonSquare,
                  new AssetImage("assets/images/padlock.png")),
              _buildAction(
                  "Achievments", () {}, FlatColors.londonSquare,
                  new AssetImage("assets/images/padlock.png")),
            ],
          ),
        ],
      ),

    );
  }

  Widget _buildAction(String title, VoidCallback action, Color color, ImageProvider backgroundImage) {
    final textStyle = new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 18.0);

    return new GestureDetector(
      onTap: action,
      child: new Container(
        margin: const EdgeInsets.only(right: 5.0, left: 5.0),
        width: 150.0,
        decoration: new BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(24.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(color: Colors.black12,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: new Offset(0.0, 1.0)),
            ],
        ),
        child: new Stack(
          children: <Widget>[
            new Opacity(
              opacity: 0.6,
              child: new Align(
                alignment: Alignment.bottomRight,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 44.0),
                    new Image(
                      width: 64.0,
                      height: 64.0,
                      image: backgroundImage != null
                          ? backgroundImage
                          : new AssetImage("assets/images/padlock.png"),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ), // END BACKGROUND IMAGE
            new Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: new Text(title, style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
