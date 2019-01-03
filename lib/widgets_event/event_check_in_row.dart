import 'package:flutter/material.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'dart:async';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/utils/time_calc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckInEventRow extends StatefulWidget {

  final EventPost eventPost;
  final String uid;
  CheckInEventRow(this.uid, this.eventPost);

  @override
  _CheckInEventRowState createState() => _CheckInEventRowState();
}

class _CheckInEventRowState extends State<CheckInEventRow> {

  bool isLoading = false;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0, color: Colors.white);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);
  final TextStyle boldBodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: FlatColors.blackPearl);
  final TextStyle statTextStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: FlatColors.lightAmericanGray);


  Future<bool> unavailableMessage(BuildContext context, String header, String body) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return FailureDialog(header: header, body: body); });
  }

  Future<bool> actionMessage(BuildContext context, String eventTitle, VoidCallback callback) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return EventCheckInDialog(eventTitle: eventTitle, confirmAction: callback);});
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
    } else if (widget.eventPost.attendees.contains(widget.uid)) {
      unavailableMessage(context, "View Attendees?", "Next Available Time " + availableCheckInTime);
    } else {
      setState(() {
        isLoading = false;
      });
      unavailableMessage(context, "You've Recently Checked In at Another Event.", "Next Available Time " + availableCheckInTime);
    }
  }

  void checkIntoEvent() async {
    Navigator.pop(context);
    print(widget.eventPost.endDateInMilliseconds);
    UserDataService().updateEventCheckIn(widget.uid, widget.eventPost).then((error){
      widget.eventPost.attendees.add(widget.uid);
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
                size: Size.fromHeight(MediaQuery.of(context).size.height * 0.4),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    /// Item description inside a material
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: CachedNetworkImageProvider(widget.eventPost.pathToImage), fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [BoxShadow(
                          color: FlatColors.londonSquare,
                          blurRadius: 4.0,
                          offset: Offset(0.0, 5.0),
                        ),]
                      ),
                      margin: EdgeInsets.only(top: 24.0),
                      child: InkWell(
                        onTap: () {userCheckInAction();},
                        child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              /// Title and rating
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          Text(widget.eventPost.title, style: headerTextStyle),
                                          Text('${widget.eventPost.startTime} - ${widget.eventPost.endTime}', style: subHeaderTextStyle),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              /// Infos
                              Row(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  StreamBuilder(
                                      stream: Firestore.instance.collection("eventposts").document(widget.eventPost.eventKey).snapshots(),
                                      builder: (context, eventSnapshot) {
                                        if (!eventSnapshot.hasData) return Text("Loading...");
                                        var eventData = eventSnapshot.data;
                                        List attendanceCount = eventData['attendees'];
                                        int endInMilliseconds = int.parse(eventData['endDateInMilliseconds']);

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                           Padding(
                                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                                             child: Material(
                                               borderRadius: BorderRadius.circular(8.0),
                                               color: FlatColors.darkGray,
                                               child: Padding(
                                                 padding: EdgeInsets.all(4.0),
                                                 child: attendanceCount.isEmpty
                                                     ? Text('0 users', style: TextStyle(color: Colors.white))
                                                     : Text('${attendanceCount.length} users', style: TextStyle(color: Colors.white)),
                                               ),
                                             ),
                                           ),
                                            SizedBox(height: 4.0),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 8.0),
                                              child: Material(
                                                borderRadius: BorderRadius.circular(8.0),
                                                color: FlatColors.greenTeal,
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text('Ends in ${TimeCalc().showTimeRemaining(endInMilliseconds)}', style: TextStyle(color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                          ],
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
                    /// Item image
                    widget.eventPost.flashEvent != null || widget.eventPost.flashEvent == true
                    ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(24.0),
                          child: Material(
                            elevation: 2.0,
                            shadowColor: Color(0x802196F3),
                            shape: CircleBorder(),
                            child: Icon(FontAwesomeIcons.bolt, size: 20.0, color: FlatColors.webblenRed,)
                          ),
                        ),
                      ),
                    )
                    : Container(),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}