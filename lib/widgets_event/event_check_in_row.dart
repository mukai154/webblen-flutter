import 'package:flutter/material.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'dart:async';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/utils/time_calc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/utils/create_notification.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/widgets_icons/icon_bubble.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/widgets_common/common_progress.dart';

class CheckInEventRow extends StatefulWidget {

  final EventPost eventPost;
  final String uid;
  final VoidCallback viewEventAction;
  CheckInEventRow({this.uid, this.eventPost, this.viewEventAction});

  @override
  _CheckInEventRowState createState() => _CheckInEventRowState();
}

class _CheckInEventRowState extends State<CheckInEventRow> {


  bool isLoading = false;

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
    String availableCheckInTime = await UserDataService().eventCheckInStatus(widget.uid);
    if (availableCheckInTime.isEmpty){
      checkIntoEvent();
    } else {
      ShowAlertDialogService().showFailureDialog(context, "You've Recently Checked In at Another Event", 'Next Available Time: $availableCheckInTime');
    }
  }


  void checkIntoEvent() async {
    UserDataService().updateEventCheckIn(widget.uid, widget.eventPost).then((error){
      //widget.eventPost.attendees.add(widget.uid);
      CreateNotification().createTimedNotification(
        101,
          DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
          'Cooldown Complete!',
          'You can now check into another event',
          null
      );
    });
  }

  void checkoutOfEvent() async {
    UserDataService().checkoutOfEvent(widget.uid, widget.eventPost).then((error){
      if (error.isEmpty){
        CreateNotification().deleteTimedNotification(101);
      } else {
        ShowAlertDialogService().showFailureDialog(context, "Uh Oh!", 'There was an issue checking out. Please Try Again');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List attendanceCount = widget.eventPost.attendees;
    String endTime = TimeCalc().showTimeRemaining(int.parse(widget.eventPost.endDateInMilliseconds));
    String estimatedPayout =  (widget.eventPost.eventPayout.toDouble() * 0.05).toStringAsFixed(2);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: widget.viewEventAction,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            boxShadow: ([
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1.8,
                spreadRadius: 0.5,
                offset: Offset(0.0, 3.0),
              ),
            ])
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0),
                    child: Fonts().textW800(widget.eventPost.title, 18.0, FlatColors.darkGray, TextAlign.start),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.black12,
                      child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Fonts().textW500('Ends in $endTime', 12.0, Colors.black87, TextAlign.center)
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 280.0,
                child: CachedNetworkImage(
                  imageUrl: widget.eventPost.pathToImage,
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start ,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(8.0),
                          color: FlatColors.greenTeal,
                          child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Fonts().textW700('Payout Pool: \$$estimatedPayout', 16.0, Colors.white, TextAlign.center)
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0, left: 10.0, bottom: 8.0),
                        child: attendanceCount == null || attendanceCount.isEmpty
                            ? Fonts().textW500('0 Check Ins', 12.0, Colors.black38, TextAlign.center)
                            : Fonts().textW500(
                            attendanceCount.length == 1 ? '${attendanceCount.length} Check Ins' : '${attendanceCount.length} Check Ins',
                            12.0, Colors.black38,
                            TextAlign.center
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      CustomColorButton(
                        text: widget.eventPost.attendees.contains(widget.uid) ? 'Check Out' : 'Check In',
                        textColor: widget.eventPost.attendees.contains(widget.uid) ? Colors.white : FlatColors.darkGray,
                        backgroundColor: widget.eventPost.attendees.contains(widget.uid) ? Colors.redAccent : Colors.white,
                        height: 45.0,
                        width: 100.0,
                        hPadding: 8.0,
                        vPadding: 0.0,
                        onPressed: widget.eventPost.attendees.contains(widget.uid) ? () => checkoutOfEvent() : () => userCheckInAction(),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}