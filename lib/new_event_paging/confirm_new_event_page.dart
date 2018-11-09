import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/widgets_event/event_details_summary.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'dart:async';
import 'package:webblen/utils/online_images.dart';
import 'package:webblen/widgets_dashboard/dashboard_tile.dart';
import 'package:webblen/widgets_event/event_details_tile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/widgets_common/common_alert.dart';


class ConfirmEventPage extends StatefulWidget {

  final EventPost newEvent;
  final File newEventImage;
  ConfirmEventPage({this.newEvent, this.newEventImage});

  @override
  _ConfirmEventPageState createState() => _ConfirmEventPageState();
}

class _ConfirmEventPageState extends State<ConfirmEventPage> {

  String uid;
  String username;
  bool isLoading = false;


  final TextStyle lightHeaderTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.white);
  final TextStyle lightSubHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white);
  final TextStyle graySubHeaderTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 12.0, color: FlatColors.clouds);
  final TextStyle lightBodyTextStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.white);
  final TextStyle lightStatTextStyle =  TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.white);

  List<String> imageAddresses = OnlineImages.imageAddresses;

  // ** BACKGROUND IMAGE
  Container _getBackground () {
    return new Container(
      child: widget.newEventImage == null
          ? new Image.network(imageAddresses[Random().nextInt(14)],
          fit: BoxFit.cover,
          height: 300.0)
          : new Image.file(widget.newEventImage,
          fit: BoxFit.cover,
          height: 300.0),
      constraints: new BoxConstraints.expand(height: 300.0),
    );
  }

  // ** BACKGROUND GRADIENT
  Widget _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
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
              child: EventDetailsSummary(widget.newEvent, horizontal: false,),
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
            DashboardTile(
              child: isLoading? _buildLoadingIndicator()
                  : Center(
                child: Text("Submit"),
              ),
              onTap: () => uploadEvent(),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 320.0),
            StaggeredTile.extent(1, 120.0),
            StaggeredTile.extent(1, 120.0),
            StaggeredTile.extent(1, 120.0),
            StaggeredTile.extent(1, 120.0),
            StaggeredTile.extent(2, 100.0),
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

  Widget _buildLoadingIndicator(){
    return Theme(
      data: ThemeData(
          accentColor: FlatColors.londonSquare
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(backgroundColor: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> successAlert(BuildContext context) {
    setState(() {
      isLoading = false;
    });
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return EventUploadSuccessDialog();
        });
  }

  Future<bool> failedAlert(BuildContext context, String details) {
    setState(() {
      isLoading = false;
    });
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/warning.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Text("Event Submission Failed", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: new Text("There Was an Issue Submitting Your Event: $details", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<bool> showEventInfoDialog(BuildContext context, String infoType) {
    Widget infoDialog;
    if (infoType == "description"){
      infoDialog = DescriptionEventInfoDialog(description: widget.newEvent.description);
    } else if (infoType == "date & time"){
      infoDialog = DateTimeEventInfoDialog(date: widget.newEvent.startDate, startTime: widget.newEvent.startTime, endTime: widget.newEvent.endTime);
    } else if (infoType == "address"){
      infoDialog = LocationEventInfoDialog(address: widget.newEvent.address, lat: widget.newEvent.lat, lon: widget.newEvent.lon);
    } else if (infoType == "additional info"){
      infoDialog = AdditionalEventInfoDialog(estimatedTurnout: widget.newEvent.estimatedTurnout, eventCost: widget.newEvent.costToAttend);
    }
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return infoDialog;
        });
  }

  uploadEvent() async {
    setState(() {
      isLoading = true;
    });
    EventPostService().uploadEvent(widget.newEventImage, widget.newEvent, username).then((result){
      if (result.toString() == "success"){
        successAlert(context);
      } else {
        failedAlert(context, result.toString());
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
        UserDataService().currentUsername(val).then((currentUsername){
          setState(() {
            username = currentUsername;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: Colors.white,
        child: new Stack (
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
            _getToolbar(context),
          ],
        ),
      ),
    );
  }
}