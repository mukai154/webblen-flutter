import 'package:flutter/material.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/common_widgets/common_event_separator.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/custom_widgets/event_details_summary.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/common_widgets/common_button.dart';
import 'dart:io';
import 'dart:async';
import 'package:webblen/utils/online_images.dart';

class ConfirmEventPage extends StatefulWidget {

  static String tag = "confirm-event-page";

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
  final StorageReference storageReference = FirebaseStorage.instance.ref();

  final TextStyle lightHeaderTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.white);
  final TextStyle lightSubHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white);
  final TextStyle lightBodyTextStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.white);
  final TextStyle lightStatTextStyle =  TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.white);

  static String tag = "event-details-page";
  final eventsColor = Gradients.blueMalibuBeach();
  final myEventsColor = Gradients.smartIndigo();
  final testData = EventPost.eventTestData();
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
            FlatColors.electronBlueLowOpacity,
            FlatColors.electronBlue,
          ],
          stops: [0.0, 3.0],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 0.8),
        ),
      ),
    );
  }

  Widget _iconAndDataRow(IconData icon1, String data1, IconData icon2, String data2){
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Icon(icon1, size: 18.0, color: Colors.white,),
              new Container(width: 4.0),
              new Text(data1, style: lightStatTextStyle),
            ],
          ),
          new Row(
            children: <Widget>[
              new Icon(icon2, size: 18.0, color: Colors.white,),
              new Container(width: 4.0),
              new Text(data2, style: lightStatTextStyle),
            ],
          ),
        ]
    );
  }

  Widget _addressRow(){
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(Icons.map, size: 18.0, color: Colors.white),
          new Container(width: 8.0),
          new Text(widget.newEvent.address, style: lightStatTextStyle),
        ]
    );
  }

  Widget _dateTimeRow(){
    return new Row(
        children: <Widget>[
          new Icon(Icons.people, size: 18.0, color: FlatColors.londonSquare,),
          new Container(width: 8.0),
          new Text(widget.newEvent.estimatedTurnout.toString(), style: lightStatTextStyle),
        ]
    );
  }

  Widget _getContent() {
    final _overviewTitle = "Description".toUpperCase();
    return new ListView(
      padding: new EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 32.0),
      children: <Widget>[
        new EventDetailsSummary(widget.newEvent, horizontal: false,),
        new Container(
          padding: new EdgeInsets.symmetric(horizontal: 32.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(_overviewTitle, style: lightHeaderTextStyle),
              new EventSeparator(),
              new Text( widget.newEvent.description, style: lightBodyTextStyle, textAlign: TextAlign.center),
              SizedBox(height: 38.0),
              new Text("Date & Time", style: lightSubHeaderTextStyle),
              SizedBox(height: 4.0),
              widget.newEvent.endDate == ""
                  ? _iconAndDataRow(
                  Icons.event,
                  widget.newEvent.startDate,
                  Icons.access_time,
                  widget.newEvent.startTime)
                  : _iconAndDataRow(
                  Icons.event,
                  (widget.newEvent.startDate + " - " + widget.newEvent.endDate),
                  Icons.access_time,
                  widget.newEvent.startTime),
              SizedBox(height: 38.0),
              new Text("Address", style: lightSubHeaderTextStyle),
              SizedBox(height: 4.0),
              _addressRow(),
              SizedBox(height: 38.0),
              new Text("Additional Info", style: lightSubHeaderTextStyle),
              SizedBox(height: 4.0),
              _iconAndDataRow(Icons.perm_identity,
                  "No Limit",
                  Icons.attach_money,
                  "Free"),
              SizedBox(height: 16.0),
              isLoading? _buildLoadingIndicator()
              : Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(25.0),
                  shadowColor: Colors.black54,
                  elevation: 6.0,
                  child: MaterialButton(
                    minWidth: 300.0,
                    height: 50.0,
                    onPressed: () => uploadEventWithImage(widget.newEventImage, widget.newEvent),
                    color: Colors.white,
                    child: Text("Submit", style: TextStyle(color: FlatColors.electronBlue)),
                  ),
                ),
              ),
            ],
          ),
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
      child: new IconButton(icon: Icon(FontAwesomeIcons.times, size: 20.0, color: FlatColors.clouds), onPressed: () => Navigator.of(context).pop())
    );
  }

  Widget _buildLoadingIndicator(){
    return Theme(
      data: ThemeData(
          accentColor: Colors.white
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(backgroundColor: Colors.white),
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
          return AlertDialog(
            title: new Text("Event Posted!", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
            content: new Text("Interested Users Nearby Will be Notified", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
                },
              ),
            ],
          );
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
            title: new Text("Event Submission Failed", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
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

  Future<Null> uploadEvent(EventPost event) async {
    setState(() {
      isLoading = true;
    });
    final String eventKey = "${Random().nextInt(999999999)}";
    event.eventKey = eventKey;
    event.author = username;
    Firestore.instance.collection("eventposts").document(eventKey).setData(event.toMap()).whenComplete(() {
      successAlert(context);
    }).catchError((e) => failedAlert(context, e.details));
  }

  Future<Null> uploadEventWithImage(File eventImage, EventPost event) async {
    setState(() {
      isLoading = true;
    });
    final String eventKey = "${Random().nextInt(999999999)}";
    final String fileName = "$eventKey.jpg";
    final StorageUploadTask task = storageReference.child("events").child(fileName).putFile(eventImage);
    final Uri downloadUrl = (await task.future).downloadUrl;

    event.eventKey = eventKey;
    event.author = username;
    event.pathToImage = downloadUrl.toString();

    Firestore.instance.collection("eventposts").document(eventKey).setData(event.toMap()).whenComplete(() {
      successAlert(context);
    }).catchError((e) => failedAlert(context, e.details));

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
        color: FlatColors.electronBlue,
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