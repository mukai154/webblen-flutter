import 'package:flutter/material.dart';
import 'package:webblen/widgets_user/user_details_profile_pic.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/event_pages/event_details_page.dart';

class EventDetailsSummary extends StatelessWidget {

  final EventPost eventPost;
  final bool horizontal;

  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: FlatColors.blackPearl);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);
  final TextStyle statTextStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: FlatColors.lightAmericanGray);

  EventDetailsSummary(this.eventPost, {this.horizontal = true});
  EventDetailsSummary.vertical(this.eventPost): horizontal = false;

  @override
  Widget build(BuildContext context) {

    Widget _eventTurnoutStats() {
      return new Row(
          children: <Widget>[
            new Icon(Icons.people, size: 20.0, color: FlatColors.londonSquare,),
            new Container(width: 8.0),
            new Text(eventPost.estimatedTurnout.toString(),
                style: statTextStyle),
          ]
      );
    }

    Widget _eventViewsStats() {
      return new Row(
          children: <Widget>[
            new Icon(Icons.remove_red_eye, size: 20.0,
              color: FlatColors.londonSquare,),
            new Container(width: 8.0),
            new Text(eventPost.views.toString(), style: statTextStyle),
          ]
      );
    }


    final eventCardContent = new Container(
//      margin: new EdgeInsets.fromLTRB(horizontal ? 76.0 : 16.0, horizontal ? 16.0 : 16.0, 16.0, 16.0),
      child: new Column(
        crossAxisAlignment: horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 6.0),
          new Text(eventPost.title, style: headerTextStyle),
          new Text("@" + eventPost.author, style: subHeaderTextStyle),
          new Container(height: 8.0),
          new Text(eventPost.caption,
            style: bodyTextStyle,
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          new Row(
            mainAxisAlignment: horizontal ? MainAxisAlignment.end : MainAxisAlignment.center,
            children: <Widget>[
              _eventTurnoutStats(),
              new Container(width: 28.0,),
              _eventViewsStats(),
              new Container(width: 8.0,)
            ],
          )
        ],
      ),
    );

    return new GestureDetector(
      //onTap:() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailsPage(eventPost))),
      onTap: horizontal ? () => Navigator.of(context).push( new PageRouteBuilder( pageBuilder: (_, __, ___) =>  EventDetailsPage(eventPost),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        new FadeTransition(opacity: animation, child: child),),)
          : null,
      child: new Container(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UserDetailsProfilePic(userPicUrl: eventPost.authorImagePath, size: 90.0),
              SizedBox(height: 8.0),
              eventCardContent,

            ],
          )
      ),
    );
  }
}