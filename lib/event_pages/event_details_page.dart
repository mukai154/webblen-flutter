import 'package:flutter/material.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/widgets_event/event_details_summary.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/utils/online_images.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:webblen/widgets_dashboard/dashboard_tile.dart';
import 'package:webblen/widgets_event/event_details_tile.dart';
import 'package:webblen/widgets_common/common_alert.dart';

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
      height: 130.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            Colors.transparent,
            Colors.white,
          ],
          stops: [0.0, 3.0],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 0.8),
        ),
      ),
    );
  }

  // ** Header Gradient
  Container headerGradient() {
    return new Container(
      height: 24.0,
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            Colors.white,
            Colors.white12,
          ],
          stops: [0.0, 3.0],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.3),
        ),
      ),
    );
  }

  Widget _getContent() {
    return Stack(
          children: <Widget>[
            StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              children: <Widget>[
                DashboardTile(
                  child: EventDetailsSummary(widget.eventPost, horizontal: false,),
                  onTap: null,
                ),
                DashboardTile(
                  child: EventDetailsTile(detailType: "description"),
                  onTap: () => showEventInfoDialog(context, "description"),
                ),
                DashboardTile(
                  child: EventDetailsTile(detailType: "date & time"),
                  onTap: () => showEventInfoDialog(context, "date & time"),
                ),
                DashboardTile(
                  child: EventDetailsTile(detailType: "address"),
                  onTap: () => showEventInfoDialog(context, "address"),
                ),
                DashboardTile(
                  child: EventDetailsTile(detailType: "additional info"),
                  onTap: () => showEventInfoDialog(context, "additional info"),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 320.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
                StaggeredTile.extent(1, 120.0),
              ],
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

  Future<bool> showEventInfoDialog(BuildContext context, String infoType) {
    Widget infoDialog;
    if (infoType == "description"){
      infoDialog = DescriptionEventInfoDialog(description: widget.eventPost.description);
    } else if (infoType == "date & time"){
      infoDialog = DateTimeEventInfoDialog(date: widget.eventPost.startDate, startTime: widget.eventPost.startTime, endTime: widget.eventPost.endTime);
    } else if (infoType == "address"){
      infoDialog = LocationEventInfoDialog(address: widget.eventPost.address, lat: widget.eventPost.lat, lon: widget.eventPost.lon);
    } else if (infoType == "additional info"){
      infoDialog = AdditionalEventInfoDialog(estimatedTurnout: widget.eventPost.estimatedTurnout, eventCost: widget.eventPost.costToAttend);
    }
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return infoDialog;
        });
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
        color: Colors.white70,
        constraints: new BoxConstraints.expand(),
        child: new Stack (
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
            _getToolbar(context),
            headerGradient()
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