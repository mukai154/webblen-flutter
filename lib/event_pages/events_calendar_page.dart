//import 'package:flutter/material.dart';
//import 'package:webblen/styles/flat_colors.dart';
//import 'package:webblen/widgets_event/event_row.dart';
//import 'package:webblen/models/event_post.dart';
//import 'package:webblen/styles/fonts.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:location/location.dart';
//import 'package:flutter/services.dart';
//import 'package:intl/intl.dart';
//import 'package:webblen/firebase_services/event_data.dart';
//import 'package:webblen/widgets_common/common_progress.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:webblen/services_general/service_page_transitions.dart';
//import 'package:webblen/models/webblen_user.dart';
////import 'package:webblen/utils/create_geofence.dart';
//
//class EventCalendarPage extends StatefulWidget {
//
//  final WebblenUser currentUser;
//  EventCalendarPage({this.currentUser});
//
//  @override
//  _EventCalendarPageState createState() => new _EventCalendarPageState();
//}
//
//class _EventCalendarPageState extends State<EventCalendarPage> with SingleTickerProviderStateMixin {
//
//
//  //Firebase
//  final eventRef = Firestore.instance.collection("eventposts");
//  final SwiperController swiperController = new SwiperController();
//  bool isLoading = true;
//
//  //Mapping
//  Location _location = new Location();
//  bool _permission = false;
//
//  String error;
//  double userLat;
//  double userLon;
//
//  //By Date
//  List<EventPost> eventsToday = [];
//  List<EventPost> eventsTomorrow = [];
//  List<EventPost> eventsThisWeek = [];
//  List<EventPost> eventsNextWeek = [];
//  List<EventPost> eventsThisMonth = [];
//  List<EventPost> eventsLater = [];
//
//  TabController _tabController;
//
//
//  @override
//  void initState() {
//    super.initState();
//    _tabController = new TabController(length: 6, initialIndex: 0, vsync: this);
//    initPlatformState();
//  }
//
//  // Platform messages are asynchronous, so we initialize in an async method.
//  initPlatformState() async {
//    LocationData locationData;
//    try {
//      _permission = await _location.hasPermission();
//      locationData = await _location.getLocation();
//      setState(() {
//        if (isLoading && locationData != null){
//          userLat = locationData.latitude;
//          userLon = locationData.longitude;
//          EventPostService().findEventsNearLocation(userLat, userLon).then((eventSnapshot){
//            organizeEvents(eventSnapshot);
//            eventsToday.sort((e1, e2) => int.parse(e2.startDateInMilliseconds).compareTo(int.parse(e1.startDateInMilliseconds)));
//            eventsTomorrow.sort((e1, e2) => int.parse(e2.startDateInMilliseconds).compareTo(int.parse(e1.startDateInMilliseconds)));
//            eventsThisWeek.sort((e1, e2) => int.parse(e2.startDateInMilliseconds).compareTo(int.parse(e1.startDateInMilliseconds)));
//            eventsNextWeek.sort((e1, e2) => int.parse(e2.startDateInMilliseconds).compareTo(int.parse(e1.startDateInMilliseconds)));
//            eventsThisMonth.sort((e1, e2) => int.parse(e2.startDateInMilliseconds).compareTo(int.parse(e1.startDateInMilliseconds)));
//          });
//        }
//      });
//      error = null;
//    } on PlatformException catch (e) {
//      if (e.code == 'PERMISSION_DENIED') {
//        error = 'Permission denied';
//      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
//        error = 'Permission denied - Please Enable Location Services';
//      }
//      locationData = null;
//    }
//  }
//
//  //Organize Events
//  organizeEvents(List<DocumentSnapshot> eventSnapshot){
//    eventSnapshot.forEach((eventDoc) {
//      bool userIsInterested = false;
//      var eventTags = eventDoc.data["tags"];
//      for (var i = 0; i < eventTags.length; i++) {
//        if (widget.currentUser.tags.contains(eventTags[i])){
//          userIsInterested = true;
//          break;
//        }
//      }
//      if (userIsInterested) {
//        EventPost interestedEvent = EventPost.fromMap(eventDoc.data);
//        sortByDate(interestedEvent);
//      }
////      if (eventSnapshot.last == eventDoc){
////        createGeoFences();
////      }
//    });
//    setState(() {
//      isLoading = false;
//    });
//  }
//
//  sortByDate(EventPost event){
//    DateFormat formatter = new DateFormat("MM/dd/yyyy");
//    DateTime today = DateTime.now();
//    DateTime eventDate = formatter.parse(event.startDate);
//    if (eventDate.month == today.month && eventDate.day == today.day){
//      if (!eventsToday.contains(event)){
//        setState(() {
//          eventsToday.add(event);
//        });
//      }
//    } else if (eventDate.difference(today) <= Duration(days: 2) && eventDate.isAfter(today)){
//      if (!eventsTomorrow.contains(event)){
//        setState(() {
//          eventsTomorrow.add(event);
//        });
//      }
//    } else if (eventDate.difference(today) <= Duration(days: 7) && eventDate.isAfter(today)){
//      if (!eventsThisWeek.contains(event)){
//        setState(() {
//          eventsThisWeek.add(event);
//        });
//      }
//    } else if (eventDate.difference(today) <= Duration(days: 14) && eventDate.isAfter(today)){
//      if (!eventsNextWeek.contains(event)){
//        setState(() {
//          eventsNextWeek.add(event);
//        });
//      }
//    } else if (eventDate.difference(today) <= Duration(days: 31) && eventDate.month == today.month && eventDate.isAfter(today)){
//      if (!eventsThisMonth.contains(event)){
//        setState(() {
//          eventsThisMonth.add(event);
//        });
//      }
//    } else if (eventDate.isAfter(today) && event.recurrenceType != "weekly") {
//      var duplicate = eventsLater.firstWhere((post) => post.title == event.title, orElse: () => null);
//      if (!eventsLater.contains(event) && duplicate == null){
//        setState(() {
//          eventsLater.add(event);
//        });
//      }
//    } else if (eventDate.isBefore(today) && event.pointsDistributedToUsers == false){
//      EventPostService().distributePoints(event);
//    }
//  }
//
////  createGeoFences(){
////    List<EventPost> eventsToFence = [];
////    eventsToFence.addAll(eventsToday);
////    eventsToFence.addAll(eventsTomorrow);
////    eventsToFence.addAll(eventsThisWeek);
////    CreateGeoFence().createGeoFences(eventsToFence);
////    CreateGeoFence().getNumberOfFences();
////  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    swiperController.startAutoplay();
//    // ** APP BAR
//    final appBar = AppBar (
//      elevation: 0.0,
//      brightness: Brightness.light,
//      backgroundColor: Color(0xFFF9F9F9),
//      title: Fonts().textW700('Event Calendar', 24.0, FlatColors.darkGray, TextAlign.center),
//      leading: BackButton(color: FlatColors.darkGray),
//      bottom: new TabBar(
//        controller: _tabController,
//        indicatorColor: FlatColors.webblenRed,
//        labelColor: FlatColors.londonSquare,
//        isScrollable: true,
//        labelStyle: TextStyle(fontFamily: 'Barlow', fontWeight: FontWeight.w500),
//        tabs: <Widget>[
//          new Tab(text: "Today"),
//          new Tab(text: "Tomorrow"),
//          new Tab(text: "This Week"),
//          new Tab(text: "Next Week"),
//          new Tab(text: "This Month"),
//          new Tab(text: "Later"),
//        ],
//      ),
//    );
//
//    return Scaffold(
//      appBar: appBar,
//      body: isLoading ? _buildLoadingScreen()
//          : new TabBarView(
//        physics: NeverScrollableScrollPhysics(),
//        controller: _tabController,
//        children: <Widget>[
//          eventsToday.isEmpty ? _buildNoEvents("sleepy", "It Looks Like Nothing is Happening Today...")
//              :_buildEventList(eventsToday),
//          eventsTomorrow.isEmpty ? _buildNoEvents("vain", "Tommorrow is Going to be Uneventful")
//              : _buildEventList(eventsTomorrow),
//          eventsThisWeek.isEmpty ? _buildNoEvents("embarrassed", "No Events Happening Later this Week")
//              :_buildEventList(eventsThisWeek),
//          eventsNextWeek.isEmpty ? _buildNoEvents("surprised", "Next Week is Looking Pretty Boring...")
//              :_buildEventList(eventsNextWeek),
//          eventsThisMonth.isEmpty ? _buildNoEvents("angry", "No Events Later this Month")
//              :_buildEventList(eventsThisMonth),
//          eventsLater.isEmpty ? _buildNoEvents("crying", "Wow. This Place is Dead.")
//              :_buildEventList(eventsLater),
//        ],
//      ),
//    );
//  }
//
//  Widget _buildEventList(List<EventPost> eventList)  {
//    return Container(
//      child: ListView.builder(
//        //padding: EdgeInsets.symmetric(vertical: 8.0),
//        itemCount: eventList.length,
//        itemBuilder: (context, index){
//          return EventRow(eventPost: eventList[index], eventPostAction: () => PageTransitionService(context: context, currentUser: widget.currentUser, eventPost: eventList[index], eventIsLive: false).transitionToEventPage());
//        },
//      ),
//    );
//  }
//
//  Widget _buildNoEvents(String imageName, String message)  {
//    return new Container(
//      width: MediaQuery.of(context).size.width,
//      child: new Column /*or Column*/(
//        children: <Widget>[
//          SizedBox(height: 160.0),
//          new Container(
//            height: 85.0,
//            width: 85.0,
//            child: new Image.asset("assets/images/$imageName.png", fit: BoxFit.scaleDown),
//          ),
//          SizedBox(height: 16.0),
//          Fonts().textW400(message, 18.0, Colors.black38, TextAlign.center)
//        ],
//      ),
//    );
//  }
//
//  Widget _buildLoadingScreen()  {
//    return new Container(
//      width: MediaQuery.of(context).size.width,
//      child: new Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          SizedBox(height: 185.0),
//          CustomCircleProgress(50.0, 50.0, 40.0, 40.0, FlatColors.londonSquare),
//        ],
//      ),
//    );
//  }
//
//}