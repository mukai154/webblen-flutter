import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';

/// QuickActions represents the horizontal list of rectangular buttons below the header
class CommunityBuilderTile extends StatelessWidget {

  final VoidCallback tileAction;

  CommunityBuilderTile({this.tileAction});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildAction(
                context,
                "Post to Community",
                tileAction,
                FlatColors.vibrantYellow,
                new AssetImage("assets/images/loudspeaker.png",
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
        ],
      ),

    );
  }

  Widget _buildAction(BuildContext context, String title, VoidCallback action, Color color, ImageProvider backgroundImage) {
    final textStyle = new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 20.0);

    return new GestureDetector(
      onTap: action,
      child: new Container(
        margin: const EdgeInsets.only(right: 8.0, left: 8.0),
        width: MediaQuery.of(context).size.width * 0.86,
        decoration: new BoxDecoration(
          gradient: LinearGradient(colors: [FlatColors.vibrantYellow, FlatColors.casandoraYellow]),
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
                    SizedBox(height: 50.0),
                    new Image(
                      width: 75.0,
                      height: 64.0,
                      image: backgroundImage,
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