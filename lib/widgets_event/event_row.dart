import 'package:flutter/material.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/event_pages/event_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webblen/widgets_user/user_details_profile_pic.dart';

class EventRow extends StatelessWidget {

  final EventPost eventPost;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.white);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white);
  final TextStyle statTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.white);

  EventRow(this.eventPost);

  @override
  Widget build(BuildContext context) {

    final eventCreatorPic = UserDetailsProfilePic(userPicUrl: eventPost.authorImagePath, size: 50.0);

    final eventCreatorPicContainer = new Container(
      margin: new EdgeInsets.symmetric(vertical: 0.0),
      alignment: FractionalOffset.topLeft,
      child: eventCreatorPic,
    );

    Widget _eventDate(){
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(EventPostService().eventStartDateWeekDay(eventPost), style: statTextStyle),
            new Text(EventPostService().eventStartDateMonth(eventPost) + " " + EventPostService().eventStartDateDay(eventPost) + ", " + EventPostService().eventStartDateYear(eventPost), style: statTextStyle),
            new Text(eventPost.startTime + " - " + eventPost.endTime, style: statTextStyle),
          ]
      );
    }
    Widget _eventTurnoutStats() {
      return new Row(
          children: <Widget>[
            new Icon(Icons.people, size: 18.0, color: Colors.white),
            new Container(width: 8.0),
            new Text(eventPost.estimatedTurnout.toString(), style: statTextStyle),
          ]
      );
    }

    Widget _eventViewsStats() {
      return new Row(
          children: <Widget>[
            new Icon(Icons.remove_red_eye, size: 18.0, color: Colors.white),
            new Container(width: 8.0),
            new Text(eventPost.views.toString(), style: statTextStyle),
          ]
      );
    }


    final eventCardContent = new Container(
      //margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 46.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(eventPost.title, style: headerTextStyle),
                  Text("@" + eventPost.author, style: subHeaderTextStyle),
                ],
              ),
            ),
          ),
          Container(
            margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _eventDate(),
                  SizedBox(width: 40.0),
                  _eventTurnoutStats(),
                  SizedBox(width: 0.0),
                  _eventViewsStats(),
                ],
              ),
            ),
          )
        ],
      ),
    );

    final eventCard = new Container(
//      height: eventPost.pathToImage == "" ? 185.0 : 440.0,
      margin: new EdgeInsets.fromLTRB(20.0, 6.0, 8.0, 8.0),
      child: eventCardContent,
      decoration: new BoxDecoration(
        image: DecorationImage(image: CachedNetworkImageProvider(eventPost.pathToImage), fit: BoxFit.cover),
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(16.0),
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

class EventRowMin extends StatelessWidget {

  final EventPost eventPost;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.white);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white);
  final TextStyle statTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.white);

  EventRowMin(this.eventPost);

  @override
  Widget build(BuildContext context) {

    Widget _eventDate(){
      return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(EventPostService().eventStartDateWeekDay(eventPost), style: statTextStyle),
            new Text(EventPostService().eventStartDateMonth(eventPost) + " " + EventPostService().eventStartDateDay(eventPost) + ", " + EventPostService().eventStartDateYear(eventPost), style: statTextStyle),
            new Text(eventPost.startTime + " - " + eventPost.endTime, style: statTextStyle),
          ]
      );
    }

    final eventCardContent = new Container(
      //margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(eventPost.title, style: headerTextStyle),
                  Text("@" + eventPost.author, style: subHeaderTextStyle),
                ],
              ),
            ),
          ),
          Container(
            margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _eventDate(),
                ],
              ),
            ),
          )
        ],
      ),
    );

    final eventCard = new Container(
      height: MediaQuery.of(context).size.height * 0.54,
      margin: new EdgeInsets.fromLTRB(20.0, 6.0, 8.0, 8.0),
      child: eventCardContent,
      decoration: new BoxDecoration(
        image: DecorationImage(image: CachedNetworkImageProvider(eventPost.pathToImage), fit: BoxFit.cover),
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(16.0),
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
            ],
          )
      ),
    );
  }

}