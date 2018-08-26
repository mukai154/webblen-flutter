import 'package:flutter/material.dart';
import 'package:webblen/custom_widgets/user_profile_pic.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/event_pages/event_details_page.dart';

class EventRow extends StatelessWidget {

  final EventPost eventPost;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: FlatColors.blackPearl);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);
  final TextStyle statTextStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: FlatColors.lightAmericanGray);

  EventRow(this.eventPost);

  @override
  Widget build(BuildContext context) {


    final eventCreatorPic = new Hero (
      tag: "event-author-${eventPost.eventKey}",
      child: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.transparent,
          backgroundImage: eventPost.authorImagePath == null || eventPost.authorImagePath.isEmpty ?
            AssetImage('assets/images/user_image_placeholder.png') : NetworkImage(eventPost.authorImagePath),
      )
    );


    final eventCreatorPicContainer = new Container(
      margin: new EdgeInsets.symmetric(vertical: 0.0),
      alignment: FractionalOffset.topLeft,
      child: eventCreatorPic,
    );

    Widget _eventTurnoutStats() {
      return new Row(
          children: <Widget>[
            new Icon(Icons.people, size: 18.0, color: FlatColors.londonSquare,),
            new Container(width: 8.0),
            new Text(eventPost.estimatedTurnout.toString(), style: statTextStyle),
          ]
      );
    }

    Widget _eventViewsStats() {
      return new Row(
          children: <Widget>[
            new Icon(Icons.remove_red_eye, size: 18.0, color: FlatColors.londonSquare,),
            new Container(width: 8.0),
            new Text(eventPost.views.toString(), style: statTextStyle),
          ]
      );
    }


    final eventCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(45.0, 6.0, 14.0, 6.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          Hero(
            tag: "event-title-${eventPost.eventKey}",
            child: new Text(eventPost.title, style: headerTextStyle),
          ),
          Hero(
            tag: "event-username-${eventPost.eventKey}",
            child: new Text("@" + eventPost.author, style: subHeaderTextStyle),
          ),
          new Container(height: 8.0),
          new Text(eventPost.caption, style: bodyTextStyle,
            maxLines: 5,
          ),
          SizedBox(height: 12.0),
         new Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             eventPost.pathToImage == ""
                 ? new SizedBox(height: 0.0)
                 : new ClipRRect(
                  child: new Image.network(eventPost.pathToImage, width: 250.0,),
               borderRadius: BorderRadius.circular(16.0),
             ),
           ],
         ),
          eventPost.pathToImage == ""
            ? new SizedBox(height: 5.0)
            : new SizedBox(height: 12.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _eventTurnoutStats(),
              new Container(width: 28.0,),
              _eventViewsStats(),
              new Container(width: 4.0,)
            ],
          )
        ],
      ),
    );

    final eventCard = new Container(
//      height: eventPost.pathToImage == "" ? 185.0 : 440.0,
      margin: new EdgeInsets.fromLTRB(24.0, 6.0, 8.0, 8.0),
      child: eventCardContent,
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
      onTap:() => Navigator.push(context, ScaleRoute(widget: EventDetailsPage(eventPost))),
      child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: new Stack(
            children: <Widget>[
              eventCard,
              eventCreatorPicContainer,
            ],
          )
      ),
    );
  }

}