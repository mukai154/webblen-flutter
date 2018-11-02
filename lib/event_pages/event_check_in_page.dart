import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/models/event_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/styles/gradients.dart';
import 'dart:async';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/widgets_event/event_check_in_row.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

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
        builder: (BuildContext context) { return AlertMessage(message); });
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
                setState(() {
                  currentLat = result["latitude"];
                  currentLon = result["longitude"];
                });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlatColors.subtleBlue,
      appBar: AppBar(
        elevation: 6.0,
        backgroundColor: FlatColors.exodusPurple,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Check In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: nearbyEventsList.isEmpty ? _buildNoEvents("scan") : _buildEventList(nearbyEventsList),
    );
  }

  Widget _buildEventList(List<EventPost> eventList)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => new CheckInEventRow(uid, nearbyEventsList[index]),
          itemCount: nearbyEventsList.length,
          padding: new EdgeInsets.symmetric(vertical: 8.0)
      ),
    );
  }

  Widget _buildNoEvents(String imageName)  {
    return isLoading ? _buildLoadingScreen()
        : new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 180.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: new Image.asset("assets/images/$imageName.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child:
              new Text("There are Currently No Availabe Events Nearby", style: Fonts.noEventsFont, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
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
}