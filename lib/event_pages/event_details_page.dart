import 'package:flutter/material.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webblen/widgets_common/common_event_separator.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/widgets_event/event_details_summary.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/utils/online_images.dart';
import 'dart:math';
import 'dart:async';


class EventDetailsPage extends StatefulWidget {
  final EventPost eventPost;
  EventDetailsPage(this.eventPost);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  final eventDetailsScaffoldKey = new GlobalKey<ScaffoldState>();
  final TextStyle lightHeaderTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.white);
  final TextStyle lightSubHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white);
  final TextStyle lightBodyTextStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.white);
  final TextStyle lightStatTextStyle =  TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.white);
  final TextStyle lightAddressTextStyle =  TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.white);

  static String tag = "event-details-page";
  final eventsColor = Gradients.blueMalibuBeach();
  final myEventsColor = Gradients.smartIndigo();
  final testData = EventPost.eventTestData();
  int views;
  int turnout;

  List<String> imageAddresses = OnlineImages.imageAddresses;

  Future<Null> _launchInWebViewOrVC(String url) async {
    ScaffoldState scaffold = eventDetailsScaffoldKey.currentState;
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true, statusBarBrightness: Brightness.dark);
    } else {
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Invlaid URL"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
    }
  }

  // ** BACKGROUND IMAGE
  Container _getBackground () {
       return new Container(
         child: widget.eventPost.pathToImage == ""
             ? new Image.network(imageAddresses[Random().nextInt(14)],
              fit: BoxFit.cover,
              height: 300.0)
             : new Image.network(widget.eventPost.pathToImage,
             fit: BoxFit.cover,
             height: 300.0),
         constraints: new BoxConstraints.expand(height: 300.0),
       );
  }

  // ** BACKGROUND GRADIENT
  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            FlatColors.electronBlueLowOpacity,
            FlatColors.electronBlue,
          ],
          stops: [0.0, 3.0],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 0.8),
        ),
      ),
    );
  }

  Row _IconAndDataRow(IconData icon1, String data1, IconData icon2, String data2){
  return new Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Icon(icon1, size: 18.0, color: Colors.white,),
            new Container(width: 4.0),
            new Text(data1, style: lightStatTextStyle),
          ],
        ),
        new Row(
          children: <Widget>[
            new Icon(icon2, size: 18.0, color: Colors.white,),
            new Container(width: 4.0),
            new Text(data2, style: lightStatTextStyle),
          ],
        ),
      ]
    );
  }

  Row _AddressRow(){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(Icons.map, size: 18.0, color: Colors.white),
          new Container(width: 8.0),
          new Text(widget.eventPost.address.substring(0, widget.eventPost.address.length - 5), style: lightAddressTextStyle),
        ],
    );
  }

  Row _DateTimeRow(){
    return new Row(
        children: <Widget>[
          new Icon(Icons.people, size: 18.0, color: FlatColors.londonSquare,),
          new Container(width: 8.0),
          new Text(widget.eventPost.estimatedTurnout.toString(), style: lightStatTextStyle),
        ]
    );
  }

  Widget _getContent() {
    final _overviewTitle = "Description".toUpperCase();
    return new ListView(
      padding: new EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 32.0),
      children: <Widget>[
        new EventDetailsSummary(widget.eventPost, horizontal: false,),
        new Container(
          padding: new EdgeInsets.symmetric(horizontal: 32.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(_overviewTitle, style: lightHeaderTextStyle),
              new EventSeparator(),
              widget.eventPost.description.isNotEmpty ? new Text(widget.eventPost.description, style: lightBodyTextStyle, textAlign: TextAlign.center)
              : SizedBox(height: 16.0),
              widget.eventPost.description.isNotEmpty ? SizedBox(height: 24.0)
                  : SizedBox(),
              new Text("Date & Time", style: lightSubHeaderTextStyle),
              SizedBox(height: 4.0),
              _IconAndDataRow(
                  Icons.event,
                  (widget.eventPost.startDate),
                  Icons.access_time,
                  widget.eventPost.startTime + " - " + widget.eventPost.endTime),
              SizedBox(height: 38.0),
              new Text("Address", style: lightSubHeaderTextStyle),
              SizedBox(height: 4.0),
              _AddressRow(),
              SizedBox(height: 38.0),
              new Text("Additional Info", style: lightSubHeaderTextStyle),
              SizedBox(height: 4.0),
              _IconAndDataRow(Icons.perm_identity,
                  "No Limit",
                  Icons.attach_money,
                  "Free"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getToolbar(BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 2.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 1.3),
              ),
            ]
        ),
        margin: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: new IconButton(icon: Icon(FontAwesomeIcons.times, size: 20.0, color: FlatColors.darkGray), onPressed: () => Navigator.of(context).pop())
    );
  }

  @override
  void initState() {
    super.initState();
    EventPostService().updateEventViews(widget.eventPost.eventKey).then((eventViews){
      setState(() {
        views = eventViews;
      });
      EventPostService().updateEstimatedTurnout(widget.eventPost.eventKey).then((eventTurnout){
        setState(() {
          turnout = eventTurnout;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: eventDetailsScaffoldKey,
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: FlatColors.electronBlue,
        child: new Stack (
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
            _getToolbar(context),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          widget.eventPost.twitterSite.isNotEmpty ? SpeedDialChild(
              child: Icon(FontAwesomeIcons.twitter),
              backgroundColor: FlatColors.twitterBlue,
              onTap: () => _launchInWebViewOrVC(widget.eventPost.twitterSite))
              : SpeedDialChild(
              child: Icon(FontAwesomeIcons.twitter, color: FlatColors.darkGray),
              backgroundColor: FlatColors.londonSquare),
          widget.eventPost.fbSite.isNotEmpty ? SpeedDialChild(
            child: Icon(FontAwesomeIcons.facebook),
            backgroundColor: FlatColors.facebookBlue,
            onTap: () => _launchInWebViewOrVC(widget.eventPost.fbSite))
          : SpeedDialChild(
              child: Icon(FontAwesomeIcons.facebook, color: FlatColors.darkGray),
              backgroundColor: FlatColors.londonSquare),
          widget.eventPost.website.isNotEmpty ? SpeedDialChild(
            child: Icon(FontAwesomeIcons.globe),
            backgroundColor: Colors.green,
            onTap: () => _launchInWebViewOrVC(widget.eventPost.website))
          : SpeedDialChild(
              child: Icon(FontAwesomeIcons.globe, color: FlatColors.darkGray),
              backgroundColor: FlatColors.londonSquare),
        ],
      ),
    );
  }

}

