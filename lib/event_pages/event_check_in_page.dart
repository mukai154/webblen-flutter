import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/models/event_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/widgets_event/event_check_in_row.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/services_general/services_show_alert.dart';


class EventCheckInPage extends StatefulWidget {


  @override
  _EventCheckInPageState createState() => _EventCheckInPageState();
}

class _EventCheckInPageState extends State<EventCheckInPage> {
  String uid;
  String currentUsername;
  List<EventPost> nearbyEventsList = [];
  bool isLoading = true;
  double currentLat;
  double currentLon;

  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = new Location();
  bool retrievedLocation = false;
  bool _permission = false;

  Future<Null> invalidAlert(BuildContext context, String message) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return FailureDialog(header: "Invalid", body: message); });
  }

  Future<Null> getAndOrganizeEvents() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("eventposts").where('author', isEqualTo: currentUsername).getDocuments();
    var eventsSnapshot = querySnapshot.documents;
    eventsSnapshot.forEach((eventDoc) {
      EventPost event = EventPostService().createEventPost(eventDoc);
      setState(() {
        nearbyEventsList.add(event);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> showEventInfoDialog(BuildContext context, String infoType, String message) {
    Widget infoDialog;
    if (infoType == "createFlashEvent"){
      infoDialog = CreateFlashEventDialog(
          confirmAction: () => transitionToNewFlashEvent(),
          explainAction: null);
    } else if (infoType == "invalid"){
      infoDialog = FailureDialog(header: "Invalid Check In", body: message);
    }
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return infoDialog;
        });
  }

  transitionToNewFlashEvent(){
    Navigator.of(context).pop();
    PageTransitionService(context: context, uid: uid).transitionToNewFlashEventPage();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initLocationState() async {
    Map<String, double> location;
    String error = "";
    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Location Permission Denied';
        invalidAlert(context, error);
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - Please Enable Location Services From App Settings';
        invalidAlert(context, error);
      }
      location = null;
    }
    setState(() {
      _startLocation = location;
    });
  }

  Widget buildEventsCheckInBody(){
    return new CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        title: Text('Check In', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87)),
        elevation: 1.0,
        floating: true,
        snap: true,
        backgroundColor: Color(0xFFF9F9F9),
        brightness: Brightness.light,
        leading: BackButton(color: Colors.black38),
        actions: <Widget>[
          IconButton(
            onPressed: () => showEventInfoDialog(context, "createFlashEvent", null),
            icon: Icon(FontAwesomeIcons.bolt, size: 24.0, color: FlatColors.londonSquare),
          ),
        ],
      ),
      new SliverList(
        delegate: new SliverChildListDelegate(
          nearbyEventsList.isNotEmpty
              ? buildEventCheckInList(nearbyEventsList)
              : buildNoEventsList(),
        ),
      ),
    ]);
  }

  List buildEventCheckInList(List<EventPost> eventList) {
    List<Widget> eventsCheckInList = List();
    for (int i = 0; i < eventList.length; i++) {
      eventsCheckInList.add(
        Padding(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          child: new CheckInEventRow(uid, nearbyEventsList[i]),
        ),
      );
    }
    return eventsCheckInList;
  }

  List buildNoEventsList() {
    List<Widget> widgets = List();
    for (int i = 0; i < 1; i++) {
      widgets.add(
          isLoading ? _buildLoadingScreen()
              : new Container(
            width: MediaQuery.of(context).size.width,
            child: new Column(
              children: <Widget>[
                SizedBox(height: 160.0),
                new Container(
                  height: 85.0,
                  width: 85.0,
                  child: new Image.asset("assets/images/scan.png", fit: BoxFit.scaleDown),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                  new Text("There are Currently No Availabe Events Nearby", style: Fonts.noEventsFont, textAlign: TextAlign.center),
                ),
                SizedBox(height: 8.0),
                CustomColorButton("Create Flash Event", 45.0, MediaQuery.of(context).size.width * 0.8, () => showEventInfoDialog(context, "createFlashEvent", null), FlatColors.webblenRed, Colors.white)
              ],
            ),
          ),
      );
    }
    return widgets;
  }


  Widget _buildLoadingIndicator(){
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(backgroundColor: FlatColors.darkGray),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen()  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 240.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: _buildLoadingIndicator(),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }



  @override
  void initState() {
    super.initState();
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
        _locationSubscription =
            _location.onLocationChanged().listen((Map<String,double> result) {
              if (this.mounted){
                currentLat = result["latitude"];
                currentLon = result["longitude"];
                if (!retrievedLocation){
                  EventPostService().findEventsForCheckIn(currentLat, currentLon).then((events){
                    setState(() {
                      isLoading = false;
                      retrievedLocation = true;
                      nearbyEventsList = events;
                    });
                  });
                }
              }
            });

      });
    });
  }

  //UserDataService().addUserDataField("eventPoints", 0);
  //EventPostService().populateData("11/27/2018");
  //EventPostService().addEventDataField("actualTurnout", 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildEventsCheckInBody(),
    );
  }

}