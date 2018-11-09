import 'package:flutter/material.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'dart:async';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckInEventRow extends StatefulWidget {

  final EventPost eventPost;
  final String uid;
  CheckInEventRow(this.uid, this.eventPost);

  @override
  _CheckInEventRowState createState() => _CheckInEventRowState();
}

class _CheckInEventRowState extends State<CheckInEventRow> {

  bool isLoading = false;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: FlatColors.blackPearl);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);
  final TextStyle boldBodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: FlatColors.blackPearl);
  final TextStyle statTextStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: FlatColors.lightAmericanGray);


  Future<bool> unavailableMessage(BuildContext context, String messageHeader, String messageA, String messageB) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return UnavailableMessage(messageHeader: messageHeader, messageA: messageA, messageB: messageB); });
  }

  Future<bool> actionMessage(BuildContext context, String eventTitle, VoidCallback callback) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return EventCheckInDialog(eventTitle: eventTitle, confirmAction: callback);});
  }

  Future<bool> alertMessage(BuildContext context, String message) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return AlertMessage(message); });
  }

  Future<bool> successMessage(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return EventCheckInSuccessDialog(); });
  }


  void userCheckInAction() async {
    setState(() {
      isLoading = true;
    });
    String availableCheckInTime = await UserDataService().eventCheckInStatus(widget.uid);
    if (availableCheckInTime.isEmpty){
      actionMessage(context, widget.eventPost.title, checkIntoEvent);
    } else {
      setState(() {
        isLoading = false;
      });
      String messageA = "You've Recently Checked In at Another Event.";
      String messageB = "Next Available Time " + availableCheckInTime;
      unavailableMessage(context, "Event Check-In Unavailable", messageA, messageB);
    }
  }

  void checkIntoEvent() async {
    Navigator.pop(context);
    UserDataService().updateEventCheckIn(widget.uid, widget.eventPost).then((error){
      //print(error);
      successMessage(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Stack(
        children: <Widget>[
          /// Item card
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox.fromSize(
                size: Size.fromHeight(150.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    /// Item description inside a material
                    Container(
                      margin: EdgeInsets.only(top: 24.0),
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(12.0),
                        shadowColor: Color(0x802196F3),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {userCheckInAction();},
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /// Title and rating
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(widget.eventPost.title, style: headerTextStyle),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('${widget.eventPost.startTime} - ${widget.eventPost.endTime}', style: subHeaderTextStyle),
                                      ],
                                    ),
                                  ],
                                ),
                                /// Infos
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Users:', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                    StreamBuilder(
                                        stream: Firestore.instance.collection("eventposts").document(widget.eventPost.eventKey).snapshots(),
                                        builder: (context, eventSnapshot) {
                                          if (!eventSnapshot.hasData) return Text("Loading...");
                                          var eventData = eventSnapshot.data;
                                          List attendanceCount = eventData['attendees'];
                                          return Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                                            child: Material(
                                              borderRadius: BorderRadius.circular(8.0),
                                              color: FlatColors.greenTeal,
                                              child: Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: attendanceCount.isEmpty
                                                    ? Text('0 users', style: TextStyle(color: Colors.white))
                                                    : Text('${attendanceCount.length} users', style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    /// Item image
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(54.0),
                          child: Material(
                            elevation: 20.0,
                            shadowColor: Color(0x802196F3),
                            shape: CircleBorder(),
                            child: widget.eventPost.pathToImage == null || widget.eventPost.pathToImage.isEmpty ?
                            AssetImage('assets/images/user_image_placeholder.png')
                                : CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(widget.eventPost.pathToImage)),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}