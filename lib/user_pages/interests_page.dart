import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/custom_widgets/gradient_app_bar.dart';
import 'package:webblen/firebase_services/tag_data.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/utils/event_tags.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


class InterestsPage extends StatefulWidget {

  static String tag = "interest-page";

  final List userTags;
  InterestsPage({this.userTags});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {

  List<String> tags;
  List<String> selectedTags = [];
  String uid;
  bool isLoading = true;

  // ** APP BAR
  final appBar = GradientAppBar("Events", Gradients.cloudyGradient() , Colors.white);

  @override
  void initState() {
    super.initState();
    setState(() {
      tags = EventTags.allTags;
    });
    widget.userTags.forEach((tag) {
      selectedTags.add(tag.toString());
    });
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final body = Container(
      width: MediaQuery.of(context).size.width,
      color: FlatColors.twinkleBlue,
      child: Column(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  _buildInterestsGrid(),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0.0,
        backgroundColor: FlatColors.carminPink,
        title: new Text("Interests", style: Fonts.subHeadTextStyleWhite),
      ),
        body: new Container(
          color: FlatColors.carminPink,
          child: isLoading ? _buildLoadingScreen()
              :new ListView(
            children: <Widget>[
              _buildInterestsGrid(),
              SizedBox(height: 16.0),
              isLoading ? _buildLoadingIndicator() : new NewEventFormButton("Update", FlatColors.carminPink, Colors.white, updateTags),
            ],
          ),
        ),
    );
  }

  Widget _buildInterestsGrid(){
    return new Hero(
      tag: "interests-red",
      child: Container(
        height: 475.0,
        child: new GridView.count(
          crossAxisCount: 4,
          scrollDirection: Axis.horizontal,
          children: tags == null ? <Widget>[CustomCircleProgress(40.0, 40.0, 40.0, 40.0, Colors.white)]
              : new List<Widget>.generate(tags.length, (index) {
            return new GridTile(
                child: new InkResponse(
                  onTap: () => tagClicked(index),
                  child: new Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
                    color: selectedTags.contains(tags[index])
                        ? FlatColors.pinkGlamour
                        : FlatColors.carminPink,
                    child: new Center(
                      child: new Text('${tags[index]}', style: Fonts.bodyTextStyleWhite),
                    ),
                  ),
                )
            );
          }),
        ),
      ),
    );
  }

  tagClicked(int index){
    String tag = tags[index];
    if (selectedTags.contains(tag)) {
      setState(() {
        selectedTags.remove(tag);
      });
    } else {
      setState(() {
        selectedTags.add(tag);
      });
    }
  }

  Future<bool> updatedInterests(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/checked.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Text("Interests Updated", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: new Text("Check Out Your Calendar to See if There's Something You'd Like to Do.", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Edit Interests", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Continue", style: Fonts.alertDialogAction),
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
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Interest Update Failed", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
            content: new Text("There Was an Issue Updating Your Interests: $details", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
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

  Future<Null> updateTags() async {
    setState(() {
      isLoading = true;
    });
    CollectionReference userRef = Firestore.instance.collection("users");
    userRef.document(uid).updateData({'tags': selectedTags}).whenComplete(() {
     updatedInterests(context);
     setState(() {
       isLoading = false;
     });
    }).catchError((e) {
      failedAlert(context, e.details);
      setState(() {
        isLoading = false;
      });
    });
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
              height: 40.0,
              width: 40.0,
              child: CircularProgressIndicator(backgroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen()  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      color: FlatColors.carminPink,
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
}