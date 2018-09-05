import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/event_pages/event_details_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserRow extends StatelessWidget {

  final WebblenUser user;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: FlatColors.blackPearl);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);
  final TextStyle pointStatStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: FlatColors.londonSquare);
  final TextStyle eventStatStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: FlatColors.londonSquare);

  UserRow(this.user);

  @override
  Widget build(BuildContext context) {

    final userPic = new ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: FadeInImage.assetNetwork(placeholder: "assets/gifs/loading.gif", image: user.profile_pic, width: 60.0),
    );


    final userPicContainer = new Container(
      margin: new EdgeInsets.symmetric(vertical: 0.0),
      alignment: FractionalOffset.topLeft,
      child: userPic,
    );

    Widget userPointStats() {
      return new Row(
          children: <Widget>[
            new Icon(Icons.star_border, size: 18.0, color: FlatColors.vibrantYellow,),
            new Container(width: 8.0),
            new Text(user.eventPoints.toString(), style: pointStatStyle),
          ]
      );
    }

    Widget userEventHistoryStats() {
      return new Row(
          children: <Widget>[
            new Icon(FontAwesomeIcons.calendarAlt, size: 14.0, color: FlatColors.electronBlue),
            new Container(width: 8.0),
            new Text(user.eventHistory.length.toString(), style: eventStatStyle),
          ]
      );
    }


    final userCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(45.0, 6.0, 14.0, 6.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 8.0),
          user.username == null ? new Text("", style: headerTextStyle)
          :new Text("@" + user.username, style: headerTextStyle),
          SizedBox(height: 8.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              userPointStats(),
              new Container(width: 28.0,),
              userEventHistoryStats(),
              new Container(width: 4.0,)
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );

    final userCard = new Container(
//      height: eventPost.pathToImage == "" ? 185.0 : 440.0,
      margin: new EdgeInsets.fromLTRB(24.0, 6.0, 8.0, 8.0),
      child: userCardContent,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),

    );


    return new GestureDetector(
      onTap: null,
      child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: new Stack(
            children: <Widget>[
              userCard,
              userPicContainer,
            ],
          )
      ),
    );
  }

}