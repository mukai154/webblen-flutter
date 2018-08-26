import 'package:flutter/material.dart';
import 'package:webblen/custom_widgets/user_profile_pic.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/styles/fonts.dart';
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
    final eventCreatorPic = new Hero (
        tag: "event-author-${eventPost.eventKey}",
        child: CircleAvatar(
          radius:  horizontal? 30.0 : 45.0,
          backgroundColor: Colors.transparent,
          backgroundImage: eventPost.authorImagePath == null || eventPost.authorImagePath.isEmpty ?
          AssetImage('assets/images/user_image_placeholder.png') : NetworkImage(eventPost.authorImagePath),
        )
    );


//    CircleAvatar(
//          radius: 30.0,
//          backgroundColor: Colors.transparent,
//          backgroundImage: AssetImage('assets/images/user_pic_example.jpg'),
//    );

    final eventCreatorPicContainer = new Container(
      margin: new EdgeInsets.symmetric(vertical: 0.0),
      alignment: horizontal ? FractionalOffset.topLeft : FractionalOffset.center,
      child: eventCreatorPic,
    );

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
      margin: new EdgeInsets.fromLTRB(horizontal ? 76.0 : 16.0, horizontal ? 16.0 : 16.0, 16.0, 16.0),
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

    final eventCard = new Container(
      //height: horizontal ? 124.0 : 190.0,
      margin: horizontal ? new EdgeInsets.only(left: 46.0) : new EdgeInsets.only(top: 72.0),
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
      //onTap:() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailsPage(eventPost))),
      onTap: horizontal ? () => Navigator.of(context).push( new PageRouteBuilder( pageBuilder: (_, __, ___) =>  EventDetailsPage(eventPost),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        new FadeTransition(opacity: animation, child: child),),)
          : null,
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