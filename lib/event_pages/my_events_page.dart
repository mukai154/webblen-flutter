import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/widgets_event/my_event_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/styles/fonts.dart';

class MyEventsPage extends StatefulWidget {
  

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  String uid;
  String currentUsername;
  List<EventPost> myEventsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
        //print(uid);
        UserDataService().currentUsername(uid).then((username){
          setState(() {
            currentUsername = username;
            getAndOrganizeEvents();
          });
        });
      });
    });
//    EventPostService().populateData("10/17/2018");
//    EventPostService().populateData("11/21/2018");
//    EventPostService().populateData("12/19/2018");
//    EventPostService().populateData("01/16/2019");
//    EventPostService().populateData("02/20/2019");
//    EventPostService().populateData("03/20/2019");
//    EventPostService().populateData("04/17/2019");
//    EventPostService().populateData("05/15/2019");
//    EventPostService().populateData("06/19/2019");
//    UserDataService().addUserDataField("impactPoints", 1.00);
  }

  //UserDataService().addUserDataField("eventPoints", 0);
  //EventPostService().populateData("11/27/2018");
  //EventPostService().addEventDataField("flashEvent", false);

  Widget buildEvents(){
    return new CustomScrollView(slivers: <Widget>[
      const SliverAppBar(
        title: const Text('My Events', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87)),
        elevation: 1.0,
        floating: true,
        snap: true,
        backgroundColor: Color(0xFFF9F9F9),
        brightness: Brightness.light,
        leading: BackButton(color: Colors.black38),
      ),
      new SliverList(
        delegate: new SliverChildListDelegate(
          myEventsList.isEmpty
              ? buildNoEventsList()
              : buildEventList(myEventsList),
        ),
      ),
    ]);
  }

  List buildEventList(List<EventPost> eventList) {
    List<Widget> events = List();
    for (int i = 0; i < eventList.length; i++) {
      events.add(
        Padding(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          child: new MyEventRow(uid, eventList[i]),
        ),
      );
    }
    return events;
  }



  Widget _buildNoEvents()  {
    return isLoading ? _buildLoadingScreen()
        :new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 180.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: new Image.asset("assets/images/suspicious.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          new Text("Looks Like You haven't Created any Events", style: Fonts.noEventsFont, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  List buildNoEventsList() {
    List<Widget> widgets = List();
    for (int i = 0; i < 1; i++) {
      widgets.add(
          _buildNoEvents()
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

  Future<Null> getAndOrganizeEvents() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("eventposts").where('author', isEqualTo: currentUsername).getDocuments();
    var eventsSnapshot = querySnapshot.documents;
    eventsSnapshot.forEach((eventDoc) {
      EventPost event = EventPost.fromMap(eventDoc.data);
      setState(() {
        myEventsList.add(event);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: buildEvents(),
    );
  }

}

