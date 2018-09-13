import 'package:flutter/material.dart';
import 'package:webblen/widgets_event/event_date_tab_bar.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_event/event_row.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/widgets_common/common_progress.dart';

class EventListPage extends StatefulWidget {
  static String tag = "event-list-page";

  final List userTags;
  EventListPage({this.userTags});

  @override
  _EventListPageState createState() => new _EventListPageState();
}

class _EventListPageState extends State<EventListPage> with SingleTickerProviderStateMixin {


  //Firebase
  final eventRef = Firestore.instance.collection("eventposts");
  bool isLoading = true;

  //Mapping
  Location _location = new Location();
  bool _permission = false;

  String error;
  double userLat;
  double userLon;

  //By Date
  List<EventPost> eventsToday = [];
  List<EventPost> eventsTomorrow = [];
  List<EventPost> eventsThisWeek = [];
  List<EventPost> eventsNextWeek = [];
  List<EventPost> eventsThisMonth = [];
  List<EventPost> eventsLater = [];

  List<EventPost> selectedEventsList = EventPost.eventTestData();

  TabController _tabController;


  Future<bool> invalidAlert(BuildContext context, String message) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return AlertMessage(message); });
  }


  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 6, initialIndex: 0, vsync: this);
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, double> location;
    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();
      setState(() {
        if (isLoading && location != null){
          userLat = location["latitude"];
          userLon = location["longitude"];
          getAndOrganizeEvents(userLat, userLon);
        }
      });
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - Please Enable Location Services';
      }
      location = null;
    }
  }

  //Organize Events
  organizeEvents(List<DocumentSnapshot> eventSnapshot){
    eventSnapshot.forEach((eventDoc) {
      bool userIsInterested = false;
      var eventTags = eventDoc.data["tags"];
      for (var i = 0; i < eventTags.length; i++) {
        if (widget.userTags.contains(eventTags[i])){
          userIsInterested = true;
          break;
        }
      }
      if (userIsInterested) {
        EventPost interestedEvent = createEventPost(eventDoc);
        sortByDate(interestedEvent);
      }
      if (eventSnapshot.last == eventDoc){
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  sortByDate(EventPost event){
    DateFormat formatter = new DateFormat("MM/dd/yyyy");
    DateTime today = DateTime.now();
    DateTime eventDate = formatter.parse(event.startDate);
    if (eventDate.month == today.month && eventDate.day == today.day){
      if (!eventsToday.contains(event)){
        setState(() {
          eventsToday.add(event);
        });
      }
    } else if (eventDate.difference(today) <= Duration(days: 1) && eventDate.isAfter(today)){
      if (!eventsTomorrow.contains(event)){
        setState(() {
          eventsTomorrow.add(event);
        });
      }
    } else if (eventDate.difference(today) <= Duration(days: 7) && eventDate.isAfter(today)){
      if (!eventsThisWeek.contains(event)){
        setState(() {
          eventsThisWeek.add(event);
        });
      }
    } else if (eventDate.difference(today) <= Duration(days: 14) && eventDate.isAfter(today)){
      if (!eventsNextWeek.contains(event)){
        setState(() {
          eventsNextWeek.add(event);
        });
      }
    } else if (eventDate.difference(today) <= Duration(days: 31) && eventDate.month == today.month && eventDate.isAfter(today)){
      if (!eventsThisMonth.contains(event)){
        setState(() {
          eventsThisMonth.add(event);
        });
      }
    } else if (eventDate.isAfter(today) && event.recurrenceType != "weekly") {
     var duplicate = eventsLater.firstWhere((post) => post.title == event.title, orElse: () => null);
      if (!eventsLater.contains(event) && duplicate == null){
        setState(() {
          eventsLater.add(event);
        });
      }
    } else if (eventDate.isBefore(today) && event.pointsDistributedToUsers == false){
      EventPostService().distributePoints(event);
    }
  }

  Future<Null> getAndOrganizeEvents(lat, lon) async {
    List<DocumentSnapshot> nearbyEvents = await EventPostService().findEventsNearLocation(lat, lon);
    organizeEvents(nearbyEvents);
  }


  EventPost createEventPost(DocumentSnapshot eventDoc){
    EventPost interestedEvent = new EventPost(
      eventKey: eventDoc["eventKey"],
      title: eventDoc["title"],
      address: eventDoc["address"],
      author: eventDoc["author"],
      authorImagePath: eventDoc["authorImagePath"],
      caption: eventDoc["caption"],
      description: eventDoc["description"],
      isAdmin: eventDoc["isAdmin"],
      startDate: eventDoc["startDate"],
      endDate: eventDoc["endDate"],
      startTime: eventDoc["startTime"],
      endTime: eventDoc["endTime"],
      tags: eventDoc["tags"],
      views: eventDoc["views"],
      fbSite: eventDoc["fbSite"],
      twitterSite: eventDoc["twitterSite"],
      pathToImage: eventDoc["pathToImage"],
      website: eventDoc["website"],
      estimatedTurnout: eventDoc["estimatedTurnout"]
    );
    return interestedEvent;
  }

  @override
  Widget build(BuildContext context) {

    // ** TAB BAR
    final tabBar = EventDateTabBar(_tabController, FlatColors.electronBlue);

    // ** APP BAR
    final appBar = AppBar (
      elevation: 0.0,
      backgroundColor: FlatColors.electronBlue,
      title: Text('Events', style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white)),
      leading: BackButton(color: Colors.white),
      bottom: new TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        isScrollable: true,
        tabs: <Widget>[
          new Tab(text: "Today"),
          new Tab(text: "Tomorrow"),
          new Tab(text: "This Week"),
          new Tab(text: "Next Week"),
          new Tab(text: "This Month"),
          new Tab(text: "Later"),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: isLoading ? _buildLoadingScreen()
      : new TabBarView(
        controller: _tabController,
        children: <Widget>[
          eventsToday.isEmpty ? _buildNoEvents("sleepy", "It Looks Like Nothing is Happening Today...")
          :_buildEventList(eventsToday),
          eventsTomorrow.isEmpty ? _buildNoEvents("vain", "Tommorrow is Going to be Uneventful")
          : _buildEventList(eventsTomorrow),
          eventsThisWeek.isEmpty ? _buildNoEvents("embarrassed", "No Events Happening Later this Week")
          :_buildEventList(eventsThisWeek),
          eventsNextWeek.isEmpty ? _buildNoEvents("surprised", "Next Week is Looking Pretty Boring...")
          :_buildEventList(eventsNextWeek),
          eventsThisMonth.isEmpty ? _buildNoEvents("angry", "No Events Later this Month")
          :_buildEventList(eventsThisMonth),
          eventsLater.isEmpty ? _buildNoEvents("crying", "Wow. This Place is Dead.")
          :_buildEventList(eventsLater),
        ],
      ),
    );
  }

  Widget _buildEventList(List<EventPost> eventList)  {
    return Container(
      color: FlatColors.twinkleBlue,
      child: ListView.builder(
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                itemBuilder: (context, index) => EventRow(eventList[index]),
                itemCount: eventList.length,
                padding: EdgeInsets.symmetric(vertical: 8.0)
      ),
    );
  }

  Widget _buildNoEvents(String imageName, String message)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 160.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: new Image.asset("assets/images/$imageName.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          new Text(message, style: Fonts.noEventsFont, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen()  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      color: FlatColors.twinkleBlue,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 185.0),
          CustomCircleProgress(50.0, 50.0, 40.0, 40.0, FlatColors.londonSquare),
        ],
      ),
    );
  }

}