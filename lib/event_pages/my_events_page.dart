import 'package:flutter/material.dart';
import 'event_message_board_page.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/custom_widgets/my_event_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/styles/gradients.dart';
import 'dart:async';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/custom_widgets/event_row.dart';
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
    //UserDataService().addUserDataField("eventHistory", []);
  }

  //UserDataService().addUserDataField("eventPoints", 0);
  //EventPostService().populateData("11/27/2018");
  //EventPostService().addEventDataField("actualTurnout", 0);
  
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
          title: Text('My Events', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
        body: myEventsList.isEmpty ? _buildNoEvents("suspicious") : _buildEventList(myEventsList),
    );
  }

  Widget _buildEventList(List<EventPost> eventList)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
      child: new ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => new MyEventRow(uid, eventList[index]),
          itemCount: eventList.length,
          padding: new EdgeInsets.symmetric(vertical: 8.0)
      ),
    );
  }

  Widget _buildNoEvents(String imageName)  {
    return isLoading ? _buildLoadingScreen()
    :new Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 180.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: new Image.asset("assets/images/$imageName.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          new Text("Looks Like You haven't Created any Events", style: Fonts.noEventsFont, textAlign: TextAlign.center),
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
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
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
        myEventsList.add(event);
      });
    });
    setState(() {
      isLoading = false;
    });
  }
}

